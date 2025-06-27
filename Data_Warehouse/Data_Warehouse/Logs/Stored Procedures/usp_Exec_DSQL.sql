CREATE PROC [Logs].[usp_Exec_DSQL] @p_SourceSystem [NVARCHAR](60), @p_Sproc [NVARCHAR](100),@p_SQL [NVARCHAR](4000),@p_RowCount [BIGINT],@p_Comments [NVARCHAR](100) 
								 , @p_CustomErr [NVARCHAR](200),@p_ADFRunId [UNIQUEIDENTIFIER] 
AS
BEGIN
-- ===============================================================
-- Author:	Shaz Rehman
-- Create date: 09/08/2023
-- Ticket Ref:
-- Name: [usp_Exec_DSQL]
-- Description: Runs dynamic SQL and logs code and results to audit table
-- Revisions:
-- #32817 - SR - 20/02/2024 - Added Source System
-- ===============================================================
/*
	EXEC Logs.[usp_Exec_DSQL]
		'TestSproc'
		,'Just me testing the usp_HDMSQL_Exec_DSQL sproc but dynamic sql goes here'
		, 999
		,'Nothing to report here'
		,'Test Error'
		,'f4adf4ec-f8ca-47a1-a36b-36a792cd1b5c'
*/
SET NOCOUNT ON;
	DECLARE
		@ErrNum	INT,
		@ErrMsg	NVARCHAR(4000),
		@ErrState TINYINT
		,@RunDate DATETIME2
	SET @RunDate = GETUTCDATE()
	BEGIN TRY
		
		INSERT INTO [LOGS].[DynamicSQL]( 
			 [RUN_DTTM]
			,[SOURCE_SYSTEM]
			,[CALLING_PROC]
			,[DSQL_CODE]
			,[ROWS]
			,[COMMENTS]
			,[ADF_RUN_ID]
			)
			
		VALUES(
			 @RunDate
			,@p_SourceSystem
			,@p_Sproc
			,@p_SQL
			,@p_RowCount
			,@p_Comments
			,@p_ADFRunId
			);	
				
	END TRY
	BEGIN CATCH
	
		SELECT
			@ErrNum = ERROR_NUMBER(),
			@ErrMsg = ERROR_MESSAGE(),
			@ErrState = ERROR_STATE()
				
		IF @p_CustomErr IS NOT NULL SET @ErrMsg = @p_CustomErr + '; ' + @ErrMsg
			
		INSERT INTO [LOGS].[DynamicSQL](
			 [RUN_DTTM]
			,[SOURCE_SYSTEM]
			,[CALLING_PROC]
			,[DSQL_CODE]
			,[ERROR_NUM]
			,[ERROR_MSG]
			,[COMMENTS]
			,[ADF_RUN_ID]
			)
		VALUES(
			@RunDate
			,@p_SourceSystem
			,@p_Sproc
			,@p_SQL
			,@ErrNum
			,@ErrMsg
			,@p_Comments
			,@p_ADFRunId
			);
		SET @ErrNum += 50000; -- Need to ensure the error number is in the valid range
		THROW @ErrNum, @ErrMsg, @ErrState
	END CATCH
	
	
END