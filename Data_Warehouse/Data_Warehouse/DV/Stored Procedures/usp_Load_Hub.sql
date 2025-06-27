CREATE PROC [DV].[usp_Load_Hub] @ObjectMappingID [INT],@Debug [BIT],@RecordSource [VARCHAR](MAX),@ADFRunId [UNIQUEIDENTIFIER] AS
BEGIN
-- ===============================================================
-- Author:	Shaz Rehman
-- Create date: 11/09/2023
-- Ticket Ref: #25945
-- Name: [DV].[usp_Load_Hub]
-- Description: Runs dynamic SQL to load in all Hub Tables
-- Revisions:
-- 28855 - SR - 07/11/2023 - Amended procedure to delete and inserts rather than replace table to make way for multiple sources
-- 32194 - SR - 02/02/2024 - Amended procedure to add drop CTAS table
-- 32817 - SR - 19/02/2024 - Added ADF GUID ID to identify run and Record Source in Logging table
-- ===============================================================

	BEGIN TRY
	--SELECT * FROM ELT.DV_ObjectMapping
	--EXEC DV.usp_Load_Hub @ObjectMappingID = 106, @PipelineRunID = 'n/a', @Debug = 0, @Method = 'CTAS'
	--DECLARE @ObjectMappingID INT = 101
	--DECLARE @Debug BIT = 0
	--DECLARE @RecordSource varchar(max) = 'ADAPT'
	DECLARE @SourceSchema VARCHAR(100)
	DECLARE @SourceObject VARCHAR(100)
	DECLARE @DestinationSchema VARCHAR(100)
	DECLARE @DestinationObject VARCHAR(100)

	SELECT 
		@SourceSchema = SourceSchema,
		@SourceObject = SourceTable,
		@DestinationSchema = DestinationSchema,
		@DestinationObject = DestinationTable
	FROM ELT.DVObjectMapping WHERE ObjectMappingID = @ObjectMappingID

	DECLARE @Message NVARCHAR(MAX)
	DECLARE @SQL NVARCHAR(MAX)
	DECLARE @RowsAffected INT = 0

	--Check whether the source object exists
	DECLARE @Count INT =  0
	SELECT @Count = ISNULL(COUNT(*),0) FROM sys.objects T INNER JOIN sys.schemas S ON S.schema_id = T.schema_id
	WHERE T.name = @SourceObject AND S.Name = @SourceSchema

	IF @Count = 0
	BEGIN
		SET @Message = 'Object: ' + QUOTENAME(@SourceSchema) +'.' + QUOTENAME(@SourceObject) + ': HUB source object not found.'
		RAISERROR(@Message, 16, 0)
		--Source doesn't exist
	END

	--Check whether it is the right structure. Hub views should have 5 columns only.
	--First the key, second the record source, validfrom, validto, IsCurrent
	SET @Count = 0
	SELECT @Count = ISNULL(COUNT(*),0) 
	FROM sys.objects T 
		INNER JOIN sys.schemas S ON S.schema_id = T.schema_id
		INNER JOIN sys.columns C ON C.object_id = T.object_id
	WHERE T.name = @SourceObject AND S.Name = @SourceSchema

	IF @Count <> 5
	BEGIN
		--Wrong schema
		SET @Message = 'Object: ' + QUOTENAME(@SourceSchema) +'.' + QUOTENAME(@SourceObject) + ': HUB source objects should contain only five columns.'
		RAISERROR(@Message, 16, 0)
	END

	
	DECLARE @HubColumnName NVARCHAR(100)
	DECLARE @HubHashColumn NVARCHAR(100)
	--Get Key Column, should be the first within the view
	SET @HubColumnName = (
	SELECT TOP 1 C.Name FROM sys.objects V 
	INNER JOIN sys.schemas S ON S.schema_id = V.schema_id
	INNER JOIN sys.columns C ON C.object_id = V.object_id
	WHERE V.name = @SourceObject AND S.Name = @SourceSchema
	ORDER BY C.Column_id
	)

	SET @HubHashColumn = RIGHT(@DestinationObject,LEN(@DestinationObject)-4) + 'Hash'

	--For the CTAS method we need to know if it already exists.
	--If it does we need to swap the tables afterwards
	--Doesn't matter for insert method

/*--#25945 SR 13/09/2023 -- This step is getting the first load therefore now not required.
	DECLARE @FirstLoad BIT = 0
	IF ISNULL((
		SELECT ISNULL(COUNT(*),0) FROM sys.objects V 
		INNER JOIN sys.schemas S ON S.schema_id = V.schema_id
		WHERE V.name = @DestinationObject and S.Name = 'DV'	),0) = 0
	BEGIN
		SET @FirstLoad = 1
	END
--
*/
	--Declare @SourceRecordCount int;

	--	SET @SQL = 'select @SRC = count(*) from DV.['+@DestinationObject+'] where left(RecordSource,charindex(''.'',RecordSource)-1) = ' +''''+@RecordSource+''''
	--	--print @SQL
	--EXEC sp_executesql @SQL, N'@SRC int OUTPUT', @SRC = @SourceRecordCount OUTPUT ;

	--IF @SourceRecordCount = 0
	--begin
	--	SET @SQL = 'insert into DV.['+@DestinationObject+'] (RecordSource) values('+''''+@RecordSource+'.'')'	
	--	--print @SQL
	--	EXEC sp_executesql @SQL
	--end;

/*--#25945 SR 13/09/2023 -- This step is getting the refresh dates therefore now not required.
	DECLARE @TargetMinValidFrom DATETIME2(0) = '19000101'
	IF @FirstLoad <> 1
	BEGIN
		SET @SQL = 'SELECT @MD = MAX(ValidFrom) FROM DV.['+@DestinationObject+'] 
		where left(RecordSource,charindex(''.'',RecordSource)-1) = '+''''+@RecordSource+'''' -- added 17/01/2022 DEDMONDS - ensure multiple sources can be handled
		EXEC sp_executesql @SQL, N'@MD DATETIME2(0) OUTPUT', @MD = @TargetMinValidFrom OUTPUT
	END

	SET @SQL = CONCAT('
	INSERT INTO #VersionsToLoad
	SELECT ROW_NUMBER() OVER (ORDER BY ValidFrom ASC) AS UpdateLine, *
	FROM (
		SELECT ValidFrom, CAST(NULL AS NVARCHAR(MAX)) AS SQL FROM ', QUOTENAME(@SourceSchema), '.', QUOTENAME(@SourceObject), ' ',
		'WHERE ValidFrom > ''', @TargetMinValidFrom, '''',
		'GROUP BY ValidFrom ) S'
	)
	
	IF OBJECT_ID('tempdb..#VersionsToLoad') IS NOT NULL
	BEGIN
		DROP TABLE #VersionsToLoad
	END
	CREATE TABLE #VersionsToLoad (UpdateLine INT, ValidFrom DATETIME2(0), SQL NVARCHAR(MAX)) WITH (HEAP, DISTRIBUTION=ROUND_ROBIN)

	EXEC sp_executesql @SQL

	DECLARE @MaxValidFrom DATETIME2(0)
	SET @MaxValidFrom = (SELECT MAX(ValidFrom) FROM #VersionsToLoad)
*/

	IF OBJECT_ID('DV.' + @DestinationObject + '_CTAS','U') IS NOT NULL
	BEGIN
	SET @SQL = 'DROP TABLE DV.' + @DestinationObject + '_CTAS'
	EXEC sp_executesql @SQL
	END

--#25945 SR 13/09/2023  -- This is the new dynamic SQL build
	
	SET @SQL = CONCAT(
	'CREATE TABLE [DV].', QUOTENAME(@DestinationObject + '_CTAS'), ' WITH (HEAP, DISTRIBUTION=HASH(', QUOTENAME(RIGHT(@DestinationObject,LEN(@DestinationObject)-4) + 'Hash'), ')) AS '
	,'SELECT CAST(HASHBYTES(''SHA2_256'', ISNULL(CAST(S.', QUOTENAME(@HubColumnName), ' AS NVARCHAR(100)),'''')) AS BINARY(32)) AS ', QUOTENAME(RIGHT(@DestinationObject,LEN(@DestinationObject)-4) + 'Hash'), ', '
	,'CAST(S.', QUOTENAME(@HubColumnName), ' AS NVARCHAR(100)) AS ', QUOTENAME(RIGHT(@DestinationObject,LEN(@DestinationObject)-4) + 'Key'), ', '
	,'CAST(S.RecordSource AS VARCHAR(50)) AS RecordSource, '
	,'CAST(S.ValidFrom AS DATETIME2(0)) AS ValidFrom', ' '
	,'FROM ', QUOTENAME(@SourceSchema), '.', QUOTENAME(@SourceObject), ' AS S '
	,'WHERE S.IsCurrent = 1'
	)
	

	IF @Debug = 1
		BEGIN
			PRINT @SQL
		END
		ELSE
		BEGIN
			EXEC sp_executesql @SQL
		END
--

--#25945 SR 13/09/2023 -- This the the new auditing of the Dynamic SQL
	DECLARE @SQLCount NVARCHAR(MAX)
	DECLARE @RecCount BIGINT = 0

	SET @SQLCount = 'SELECT @COUNT = COUNT(1) FROM DV.['+@DestinationObject + '_CTAS'+']'

	EXEC sp_executesql @SQLCount, N'@Count BIGINT OUTPUT', @Count = @RecCount OUTPUT

-- 32817 - SR - 19/02/2024 - Added ADF GUID ID to identify run: @ADFRunId
	EXEC [Logs].[usp_Exec_DSQL]
	     @p_SourceSystem = @RecordSource
	   , @p_Sproc = '[DV].[usp_Load_Hub]'
	   , @p_SQL = @SQL
	   , @p_RowCount = @RecCount
	   , @p_Comments = @DestinationObject
	   , @p_CustomErr = NULL
	   , @p_ADFRunId = @ADFRunId --'f4adf4ec-f8ca-47a1-a36b-36a792cd1b5c'



/* --#25945 SR 13/09/2023 -- Old dynamic sql build now no longer required	
	--Generate CTAS script
	--If it's the first load then it puts it straight into target
	--If it's not the first it puts it into {SourceObject}_CTAS and swaps it at the end
	--If it's not the first it also Unions on the existing data and does a NOT IN for the new ones.
	--{_CTAS}
	--{Existing} CASE WHEN @FirstLoad = 1 THEN '' ELSE CONCAT('SELECT  * FROM [DV].', QUOTENAME(@DestinationObject) ,' UNION ALL ') END
	--{VersionToLoad}
	--{ExceptPreExisting} CASE WHEN @FirstLoad = 1 THEN '' ELSE
	--	CONCAT('AND CAST(HASHBYTES(''SHA2_256'', ISNULL(CAST(S.',  QUOTENAME(@HubColumnName), ' AS NVARCHAR(100)),'''')) AS BINARY(32))',  
	--	' NOT IN (SELECT ', @HubHashColumn, ' FROM DV.', @DestinationObject + ')')
	SET @SQL = CONCAT(
	'CREATE TABLE [DV].', QUOTENAME(@DestinationObject + '{_CTAS}'), ' WITH (HEAP, DISTRIBUTION=HASH(', QUOTENAME(RIGHT(@DestinationObject,LEN(@DestinationObject)-4) + 'Hash'), ')) AS '
	, ' {Existing} ' 
	,'SELECT CAST(HASHBYTES(''SHA2_256'', ISNULL(CAST(S.', QUOTENAME(@HubColumnName), ' AS NVARCHAR(100)),'''')) AS BINARY(32)) AS ', QUOTENAME(RIGHT(@DestinationObject,LEN(@DestinationObject)-4) + 'Hash'), ', '
	,'CAST(S.', QUOTENAME(@HubColumnName), ' AS NVARCHAR(100)) AS ', QUOTENAME(RIGHT(@DestinationObject,LEN(@DestinationObject)-4) + 'Key'), ', '
	,'CAST(S.RecordSource AS VARCHAR(50)) AS RecordSource, '
	,'CAST(S.ValidFrom AS DATETIME2(0)) AS ValidFrom', ' '
	,'FROM ', QUOTENAME(@SourceSchema), '.', QUOTENAME(@SourceObject), ' AS S '
	,'WHERE S.ValidFrom = {VersionToLoad} '
	,'{ExceptPreExisting}'
	)
	UPDATE V SET SQL = 
		REPLACE(
			REPLACE(
				REPLACE(
					REPLACE(@SQL,'{ExceptPreExisting}',CASE WHEN @FirstLoad = 1 AND UpdateLine = 1 THEN '' ELSE
							CONCAT('AND CAST(HASHBYTES(''SHA2_256'', ISNULL(CAST(S.',  QUOTENAME(@HubColumnName), ' AS NVARCHAR(100)),'''')) AS BINARY(32))',  
								' NOT IN (SELECT ', @HubHashColumn, ' FROM DV.', @DestinationObject + ')')
							END
							)
						,'{VersionToLoad}','''' + CAST(ValidFrom AS VARCHAR) + '''' + CASE WHEN ValidFrom = @MaxValidFrom THEN ' AND S.IsCurrent = 1 ' ELSE '' END)
					,'{Existing}', CASE WHEN @FirstLoad = 1 and UpdateLine = 1 THEN '' ELSE CONCAT('SELECT  * FROM [DV].', QUOTENAME(@DestinationObject) ,' UNION ALL ') END)
			,'{_CTAS}',CASE WHEN UpdateLine = 1 AND @FirstLoad = 1 THEN '' ELSE '_CTAS' END)
	FROM #VersionsToLoad V

	DECLARE @TotalStatements INT = (SELECT COUNT(*) FROM #VersionsToLoad)
	DECLARE @StatementBeingProcessed INT = 1

	WHILE @StatementBeingProcessed <= @TotalStatements
	BEGIN
		SET @SQL = (SELECT SQL FROM #VersionsToLoad WHERE UpdateLine = @StatementBeingProcessed)
		IF @Debug = 1
		BEGIN
			PRINT @SQL
		END
		ELSE
		BEGIN
			EXEC sp_executesql @SQL
		END
		IF NOT(@FirstLoad = 1 AND @StatementBeingProcessed = 1)
		BEGIN
			SET @SQL = 'DROP TABLE [DV].' + QUOTENAME(@DestinationObject) + '; ' +
			'RENAME OBJECT [DV].' + QUOTENAME(@DestinationObject + '_CTAS') + ' TO ' + QUOTENAME(@DestinationObject)
			IF @Debug = 1
			BEGIN
				PRINT @SQL
			END
			ELSE
			BEGIN
				EXEC sp_executesql @SQL
			END
		END
		SET @StatementBeingProcessed = @StatementBeingProcessed + 1
	END
	
	END TRY

*/


-- 28855 SR - 07/11/2023 - Instead of rename its now delete and insert to support multiple sources
/*
		SET @SQL = 'DROP TABLE [DV].' + QUOTENAME(@DestinationObject) + '; ' +
			'RENAME OBJECT [DV].' + QUOTENAME(@DestinationObject + '_CTAS') + ' TO ' + QUOTENAME(@DestinationObject)
*/
      SET @SQL = CONCAT(
	 'DELETE [DV].', QUOTENAME(@DestinationObject),' '
	,'WHERE [RecordSource] IN ( SELECT DISTINCT [RecordSource] FROM [DV].', QUOTENAME(@DestinationObject + '_CTAS') , ' AS S ) ;'
	
	,'INSERT INTO [DV].', QUOTENAME(@DestinationObject),' '
	,'SELECT S.', QUOTENAME(RIGHT(@DestinationObject,LEN(@DestinationObject)-4) + 'Hash'), ', '
	,'CAST(S.', QUOTENAME(@HubColumnName), ' AS NVARCHAR(100)) AS ', QUOTENAME(RIGHT(@DestinationObject,LEN(@DestinationObject)-4) + 'Key'), ', '
	,'CAST(S.RecordSource AS VARCHAR(50)) AS RecordSource, '
	,'CAST(S.ValidFrom AS DATETIME2(0)) AS ValidFrom', ' '
	,'FROM [DV].', QUOTENAME(@DestinationObject + '_CTAS') , ' AS S; '
-- 32194 - SR - 02/02/2024 - Amended procedure to add drop CTAS table
	,'DROP TABLE [DV].' , QUOTENAME(@DestinationObject + '_CTAS'), ';'
--


--
	)
--
		IF @Debug = 1
			BEGIN
			PRINT @SQL
			END
		ELSE
			BEGIN
				EXEC sp_executesql @SQL
			END

	END TRY

	BEGIN CATCH
		DECLARE @ErrorMessage NVARCHAR(MAX)
		SET @ErrorMessage = ERROR_MESSAGE()
		RAISERROR(@ErrorMessage,16,1)
	END CATCH
END
