CREATE PROC [ELT].[sp_CTL_DQ] AS
BEGIN

SET NOCOUNT ON
 
BEGIN TRY   

DECLARE @PipelineName NVARCHAR(1000) = 'Data Quality'
DECLARE @Datetime datetime
DECLARE @Msg varchar(2000)
DECLARE @RunID INT = CAST(COALESCE((select MAX(RunID) from ELT.CTL_Load),0) + row_number() over (order by getdate()) as INT);

declare @running BIGINT
select @running = (
					 SELECT COUNT(*) 
					 FROM [ELT].[CTL_Load] 
					 WHERE 
						[StartTime] =  (
										SELECT MAX([StartTime]) AS [StartTime] 
										FROM [ELT].[CTL_Load]
										WHERE PipelineName =  @PipelineName
										AND [StartTime] > dateadd(hh,-2,getdate())
										AND [Status] = 'Running'
										)
					)
  
IF @running = 0 

BEGIN

	DECLARE @LastLoadDate DATETIME = '01-JAN-1980'
	DECLARE @CurrentLoadDate DATE = CAST(GETDATE() AS DATE)
	DECLARE @StartTime DATETIME = GETDATE()

	--Get last successful load date
	SELECT TOP 1 @LastLoadDate = LoadDate
	FROM [ELT].CTL_Load
	WHERE [Status] = 'Success'
	ORDER BY RunID DESC

	INSERT INTO [ELT].CTL_Load
			( [RunID] ,
			  [StartTime] ,
			  [EndTime] ,
			  [DurationSeconds] ,
			  [LoadDate] ,
			  [Status],
			  [PipelineRunID],
			  [PipelineName]
			)
	VALUES  ( @RunID			, 
			  @StartTime		, -- Start - datetime
			  NULL				, -- End - datetime
			  NULL				, -- DurationSeconds - int
			  @CurrentLoadDate	, -- LoadDate - date
			  'Running'			,  -- Status - varchar(10)
			  NULL				, -- Pipeline RunID N/A
			  @PipelineName	
			)

		DECLARE @rowcount INT
		DECLARE @DN NVARCHAR(1000)

		DECLARE @ID INT

		declare @count bigint
		declare @i INT = 1
		declare @DQV varchar(500)
		DECLARE @DqExceptionID int

		IF object_id('tempdb.dbo.#tbl') is not null DROP TABLE #tbl ;
	 
	 CREATE TABLE #tbl
	  WITH
	( DISTRIBUTION = ROUND_ROBIN )
		AS
		SELECT  
			  ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS Sequence
			, [Exception_Name]
			, [DqExceptionID]
			, 'SELECT * INTO ##DQ_CHECK FROM [ELT].' + [Exception_Name] + ' OPTION (LABEL = ''DQ_CHECK'')' AS sql_code
		FROM 
			[ELT].[DQ_Exception] 
		WHERE 
			[Active] = 'Y' 
			AND [AdHoc] = 'N'
		;

	SET @count =  (select count(*) from #tbl)

	WHILE @i <= @count
	BEGIN
		SELECT @DQV = Exception_Name, @DqExceptionID = DqExceptionID FROM #tbl WHERE Sequence = @i;
		
		SET @Msg = 'Running DQ Check ' + @DQV;
		SET @Datetime = GETDATE();

			   INSERT INTO ELT.[CTL_MsgLog]
				( [RunID],
				  [ActivityName],
				  [Datetime],
				  [Msg] ,
				  [Type]
				)
				VALUES  (@RunID, @PipelineName, @Datetime, @Msg ,'I')

	-- Drop temp table

			IF object_id('tempdb.dbo.##DQ_CHECK') is not null DROP TABLE ##DQ_CHECK ;

			SET @DN = (SELECT sql_code FROM #tbl WHERE Sequence = @i);
			
			EXECUTE SP_EXECUTESQL @DN;

			SELECT TOP 1 @rowcount = row_count
			FROM 
				sys.dm_pdw_request_steps s, sys.dm_pdw_exec_requests r
			WHERE 
				r.request_id = s.request_id 
				and row_count > -1
				and r.[label] = 'DQ_CHECK'
			ORDER BY 
				r.[end_time] desc;

			SET @Datetime = GETDATE();

			SET @ID = CAST(COALESCE((select max([DqExceptionSummaryID]) from [ELT].[DQ_Exception_Summary]),0) + row_number() over (order by getdate()) as INT);

			INSERT INTO [ELT].DQ_Exception_Summary
					   ([DqExceptionSummaryID]
					   ,[DqExceptionID]
					   ,[DateTime]
					   ,[NumberOfExceptions])
			 VALUES
					   (@ID
					   ,@DqExceptionID
					   ,@Datetime
					   ,@rowcount 
					   )

			SET @Datetime = GETDATE();

			INSERT INTO [ELT].[DQ_Exception_Detail]
					   ([DqExceptionSummaryID]
					   ,[DateTime]
					   ,[Msg])
			SELECT @ID, @Datetime, DQ_Message FROM ##DQ_CHECK

			SET @Msg = 'Complete DQ Check ' + @DQV;
			SET @Datetime = GETDATE();

			INSERT INTO [ELT].[CTL_MsgLog]
				( [RunID],
				  [ActivityName],
				  [DateTime],
				  [Msg] ,
				  [Type] 
				)
			VALUES  ( @RunID, @PipelineName, @Datetime, @Msg ,'C')

			SET @i += 1;
	END

-- purge history

		IF object_id('tempdb.dbo.##DQ_PURGE') is not null DROP TABLE ##DQ_PURGE ;

		SELECT DISTINCT [DqExceptionSummaryID] INTO ##DQ_PURGE FROM [ELT].[DQ_Exception_Summary] 
		WHERE DateTime <= getdate() -366 -- one year worth

		DELETE FROM [ELT].[DQ_Exception_Detail] WHERE [DqExceptionSummaryID] IN (SELECT [DqExceptionSummaryID] FROM ##DQ_PURGE)
		DELETE FROM [ELT].[DQ_Exception_Summary] WHERE [DqExceptionSummaryID] IN (SELECT [DqExceptionSummaryID] FROM ##DQ_PURGE)

	    UPDATE [ELT].CTL_Load SET [EndTime] = GETDATE() , [Status] = 'Success', DurationSeconds=DATEDIFF(SS, StartTime, GETDATE())  WHERE [RunID] = @RunID;

END
ELSE
    SET @Datetime = GETDATE();

    INSERT INTO [ELT].[CTL_MsgLog]
				( [RunID],
				  [ActivityName],
				  [Datetime],
				  [Msg] ,
				  [Type] 
				)
		VALUES  ( 0, @PipelineName, @DateTime, 'Already Running ','I')


END TRY 
 
	BEGIN CATCH  
		SET @Datetime = GETDATE();
		SET @Msg = 'Error ' + ERROR_MESSAGE();

		UPDATE [ELT].CTL_Load SET [EndTime] = GETDATE() , [Status] = 'Failed', DurationSeconds=DATEDIFF(SS, StartTime, GETDATE())  WHERE [RunID] = @RunID;

		INSERT INTO [ELT].[CTL_MsgLog]
				( [RunID],
				  [ActivityName],
				  [Datetime] ,
				  [Msg] ,
				  [Type] 
				)
		VALUES  ( @RunID , 'DQ_Check', @Datetime, @Msg ,'E');

		THROW ;
	
    
	END CATCH  

END