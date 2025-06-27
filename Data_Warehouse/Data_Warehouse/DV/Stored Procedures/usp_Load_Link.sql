CREATE PROC [DV].[usp_Load_Link] @ObjectMappingID [INT],@Debug [BIT],@RecordSource [VARCHAR](MAX),@ADFRunId [UNIQUEIDENTIFIER] AS

BEGIN
-- ===============================================================
-- Author:	Shaz Rehman
-- Create date: 11/09/2023
-- Ticket Ref: #27456
-- Name: [DV].[usp_Load_Link]
-- Description: Runs dynamic SQL to load in all Link Tables
-- Revisions:
-- 28855 - SR - 07/11/2023 - Amended procedure to delete and inserts rather than replace table to make way for multiple sources
-- 32194 - SR - 02/02/2024 - Amended procedure to add drop CTAS table
-- 32817 - SR - 19/02/2024 - Added ADF GUID ID to identify run and Record Source in Logging table
-- ===============================================================

	--DECLARE @ObjectMappingID INT = 103
	--DECLARE @Debug BIT = 0
	--DROP TABLE DV.LINK_Customer_AdaptCase_CTAS
	--DROP TABLE DV.LINK_Customer_AdaptCase
	--EXEC [DV].usp_Load_Link @Debug = 0, @Method = 'CTAS', @FileTimeStamp = 'asa', @PipeLineRunID = '', @ObjectMappingID = 81
	--DECLARE @Debug BIT  = 1
	--DECLARE @Method VARCHAR(10) = 'CTAS'

	SET NOCOUNT ON
	BEGIN TRY
	    --DECLARE @ObjectMappingID INT = 99
	    --DECLARE @Debug BIT = 0
	    --DECLARE @RecordSource varchar(max) --= 'ADAPT'
		DECLARE @SourceSchema VARCHAR(100) --= 'ADAPT'
		DECLARE @SourceObject VARCHAR(100) --= 'LINK_Customer_AdaptCase'
		DECLARE @RowsAffected INT = 0
		DECLARE @Message NVARCHAR(MAX)
		DECLARE @SQL NVARCHAR(MAX)
	
		SELECT 
			@SourceSchema = SourceSchema,
			@SourceObject = SourceTable
		FROM ELT.DVObjectMapping WHERE ObjectMappingID = @ObjectMappingID


		IF LEN(@SourceObject) - LEN(REPLACE(@SourceObject,'_','')) <> 2 
		BEGIN
			SET @Message = 'Object: ' + QUOTENAME(@SourceSchema) +'.' + QUOTENAME(@SourceObject) + ': LINK Objects need to be in the format LINK_{HUB Object}_{Hub Object}. 2 Underscores Only'
			RAISERROR(@Message, 16, 0)
		END

		DECLARE @FirstHub NVARCHAR(100)
		DECLARE @SecondHub NVARCHAR(100)

		SET @SecondHub = RIGHT(@SourceObject,LEN(@SourceObject)-5)
		SET @FirstHub = LEFT(@SecondHub,CHARINDEX('_',@SecondHub)-1)
		SET @SecondHub = RIGHT(@SecondHub,LEN(@SecondHub)-CHARINDEX('_',@SecondHub))
	
		DECLARE @Count INT = 0

		SELECT @Count = ISNULL(COUNT(*),0) 
		FROM sys.objects T 
			INNER JOIN sys.schemas S ON S.schema_id = T.schema_id
		WHERE T.name = 'HUB_' + @FirstHub AND S.Name = 'DV'

		IF @Count <> 1
		BEGIN
			--Wrong schema
			SET @Message = 'Object: ' + QUOTENAME(@SourceSchema) +'.' + QUOTENAME(@SourceObject) + ': HUB Object ' + QUOTENAME('HUB_' + @FirstHub) + ' not found.'
			RAISERROR(@Message, 16, 0)
		END

		SET @Count = 0
		SELECT @Count = ISNULL(COUNT(*),0) 
		FROM sys.objects T 
			INNER JOIN sys.schemas S ON S.schema_id = T.schema_id
		WHERE T.name = 'HUB_' + @SecondHub AND S.Name = 'DV'

		IF @Count <> 1
		BEGIN
			--Wrong schema
			SET @Message = 'Object: ' + QUOTENAME(@SourceSchema) +'.' + QUOTENAME(@SourceObject) + ': HUB Object ' + QUOTENAME('HUB_' + @SecondHub) + ' not found.'
			RAISERROR(@Message, 16, 0)
		END
		DECLARE @DoesTableExist INT = 0

		SELECT @DoesTableExist = ISNULL(COUNT(*),0) 
		FROM sys.objects T 
			INNER JOIN sys.schemas S ON S.schema_id = T.schema_id
		WHERE T.name = @SourceObject  AND S.Name = 'DV' AND T.Type = 'U'


/*--#27456 SR 11/09/2023 -- This step is getting the refresh dates therefore now not required.
		DECLARE @TargetMinValidFrom DATETIME2(0) = '19000101'
		IF @DoesTableExist <> 0

		--BEGIN
		--	SET @SQL = 'SELECT @MD = MAX(ValidFrom) FROM DV.['+@SourceObject+']'
		--	EXEC sp_executesql @SQL, N'@MD DATETIME2(0) OUTPUT', @MD = @TargetMinValidFrom OUTPUT
		--END

		BEGIN
			SET @SQL = 'SELECT @MD = MAX(ValidFrom) FROM DV.['+@SourceObject+'] 
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
		DECLARE @FirstCol VARCHAR(100)
		DECLARE @SecondCol VARCHAR(100)
		SET @FirstCol = 
			(SELECT TOP 1 C.Name FROM sys.objects V 
			INNER JOIN sys.schemas S ON S.schema_id = V.schema_id
			INNER JOIN sys.columns C ON C.object_id = V.object_id
			WHERE V.name = @SourceObject AND S.Name = @SourceSchema
				AND C.Column_Id = 1
			ORDER BY C.Column_id)

		SET @SecondCol = 
			(SELECT TOP 1 C.Name FROM sys.objects V 
			INNER JOIN sys.schemas S ON S.schema_id = V.schema_id
			INNER JOIN sys.columns C ON C.object_id = V.object_id
			WHERE V.name = @SourceObject AND S.Name = @SourceSchema
				AND C.Column_id = 2
			ORDER BY C.Column_id
			)

		IF OBJECT_ID('DV.' + @SourceObject + '_CTAS','U') IS NOT NULL
		BEGIN
			SET @SQL = 'DROP TABLE DV.' + @SourceObject + '_CTAS'
			EXEC sp_executesql @SQL
		END

--#27456 SR 11/09/2023  -- This is the new dynamic SQL build

		 SET @SQL =  CONCAT(
			'CREATE TABLE [DV].', QUOTENAME(@SourceObject + '_CTAS'), ' ',
			'WITH (HEAP, DISTRIBUTION=REPLICATE)', ' AS ',
			'SELECT DISTINCT ',
			'CAST(',
				'HASHBYTES(''SHA2_256'',',
					'CONCAT(',
						'ISNULL(CAST(', QUOTENAME(@FirstCol), ' AS NVARCHAR(100)),''''),',
						'ISNULL(CAST(', QUOTENAME(@SecondCol), ' AS NVARCHAR(100)),'''')',
					')',
				')',
			' AS BINARY(32)) AS ', QUOTENAME(RIGHT(@SourceObject,LEN(@SourceObject)-5) + 'Hash'), ', ',
			'CAST(HASHBYTES(''SHA2_256'',ISNULL(CAST(', QUOTENAME(@FirstCol), ' AS NVARCHAR(100)),'''')) AS BINARY(32)) AS ', QUOTENAME(@FirstHub + 'Hash'), ', ',
			'CAST(HASHBYTES(''SHA2_256'',ISNULL(CAST(', QUOTENAME(@SecondCol), ' AS NVARCHAR(100)),'''')) AS BINARY(32)) AS ', QUOTENAME(@SecondHub + 'Hash'), ', ',
			'CAST(RecordSource AS VARCHAR(50)) AS RecordSource, ',
			'CAST(ValidFrom AS DateTime2(0)) AS ValidFrom ',
			'FROM ' , QUOTENAME(@SourceSchema), '.', QUOTENAME(@SourceObject), ' AS S '
			,'WHERE S.IsCurrent = 1 '
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

--#27456 SR 11/09/2023 -- This the the new auditing of the Dynamic SQL
	DECLARE @SQLCount NVARCHAR(MAX)
	DECLARE @RecCount BIGINT = 0

	SET @SQLCount = 'SELECT @COUNT = COUNT(1) FROM DV.['+@SourceObject + '_CTAS'+']'

	EXEC sp_executesql @SQLCount, N'@Count BIGINT OUTPUT', @Count = @RecCount OUTPUT

-- 32817 - SR - 19/02/2024 - Added ADF GUID ID to identify run: @ADFRunId
	EXEC [Logs].[usp_Exec_DSQL]
		 @p_SourceSystem = @RecordSource
	   , @p_Sproc = '[DV].[usp_Load_Link]'
	   , @p_SQL = @SQL
	   , @p_RowCount = @RecCount
	   , @p_Comments = @SourceObject
	   , @p_CustomErr = NULL
	   , @p_ADFRunId = @ADFRunId--'f4adf4ec-f8ca-47a1-a36b-36a792cd1b5c'

--

/* --#27456 SR 11/09/2023 -- Old dynamic sql build now no longer required
		--{_CTAS}
		--{ExistingTable} CONCAT('SELECT * FROM [DV].', QUOTENAME(@SourceObject), ' UNION ALL ')
		--{VersionToLoad}
		--{ExceptPreExisting}
		SET @SQL =
			CONCAT(
			'CREATE TABLE [DV].', QUOTENAME(@SourceObject + '{_CTAS}'), ' ',
			'WITH (HEAP, DISTRIBUTION=REPLICATE)', ' AS ',
			'{ExistingTable} ' ,
			'SELECT ',
			'CAST(',
				'HASHBYTES(''SHA2_256'',',
					'CONCAT(',
						'ISNULL(CAST(', QUOTENAME(@FirstCol), ' AS NVARCHAR(100)),''''),',
						'ISNULL(CAST(', QUOTENAME(@SecondCol), ' AS NVARCHAR(100)),'''')',
					')',
				')',
			' AS BINARY(32)) AS ', QUOTENAME(RIGHT(@SourceObject,LEN(@SourceObject)-5) + 'Hash'), ', ',
			'CAST(HASHBYTES(''SHA2_256'',ISNULL(CAST(', QUOTENAME(@FirstCol), ' AS NVARCHAR(100)),'''')) AS BINARY(32)) AS ', QUOTENAME(@FirstHub + 'Hash'), ', ',
			'CAST(HASHBYTES(''SHA2_256'',ISNULL(CAST(', QUOTENAME(@SecondCol), ' AS NVARCHAR(100)),'''')) AS BINARY(32)) AS ', QUOTENAME(@SecondHub + 'Hash'), ', ',
			'CAST(RecordSource AS VARCHAR(50)) AS RecordSource, ',
			'CAST(ValidFrom AS DateTime2(0)) AS ValidFrom ',
			'FROM ' , QUOTENAME(@SourceSchema), '.', QUOTENAME(@SourceObject), ' AS S ',
			'WHERE S.ValidFrom = {VersionToLoad} ',
			'{ExceptPreExisting}'
			)
		
		DECLARE @PreExisting NVARCHAR(MAX)
		SET @PreExisting =
			CONCAT(' AND ',
				'CAST(',
					'HASHBYTES(''SHA2_256'',',
						'CONCAT(',
							'ISNULL(CAST(', QUOTENAME(@FirstCol), ' AS NVARCHAR(100)),''''),',
							'ISNULL(CAST(', QUOTENAME(@SecondCol), ' AS NVARCHAR(100)),'''')',
						')',
					')',
				' AS BINARY(32)) ',
				'NOT IN ',
				'(SELECT ',QUOTENAME(RIGHT(@SourceObject,LEN(@SourceObject)-5) + 'Hash'), ' ',
					'FROM [DV].',QUOTENAME(@SourceObject),')')

		UPDATE V SET SQL = 
			REPLACE(
				REPLACE(
					REPLACE(
						REPLACE(@SQL,'{ExceptPreExisting}',CASE WHEN UpdateLine = 1 AND @DoesTableExist = 0 THEN '' ELSE @PreExisting END)
							,'{VersionToLoad}','''' + CAST(ValidFrom AS VARCHAR) + '''' + CASE WHEN ValidFrom = @MaxValidFrom THEN ' AND S.IsCurrent = 1 ' ELSE '' END)
						,'{ExistingTable}', CASE WHEN UpdateLine = 1 AND @DoesTableExist = 0  THEN '' ELSE CONCAT('SELECT  * FROM [DV].', QUOTENAME(@SourceObject) ,' UNION ALL ') END)
				,'{_CTAS}',CASE WHEN UpdateLine = 1 AND @DoesTableExist = 0 THEN '' ELSE '_CTAS' END)
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
			IF NOT(@DoesTableExist = 0 AND @StatementBeingProcessed = 1)
			BEGIN
				SET @SQL = 'DROP TABLE [DV].' + QUOTENAME(@SourceObject) + '; ' +
				'RENAME OBJECT [DV].' + QUOTENAME(@SourceObject + '_CTAS') + ' TO ' + QUOTENAME(@SourceObject)
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
		SET @SQL = 'DROP TABLE [DV].' + QUOTENAME(@sourceObject) + '; ' +
		'RENAME OBJECT [DV].' + QUOTENAME(@sourceObject + '_CTAS') + ' TO ' + QUOTENAME(@sourceObject)
*/
      SET @SQL =  CONCAT(   
	 'DELETE [DV].', QUOTENAME(@SourceObject),' '
	,'WHERE [RecordSource] IN ( SELECT DISTINCT [RecordSource] FROM [DV].', QUOTENAME(@SourceObject + '_CTAS') , ' AS S ) ;'

    ,'INSERT INTO [DV].', QUOTENAME(@SourceObject),' '
	,'SELECT S.', QUOTENAME(RIGHT(@SourceObject,LEN(@SourceObject)-5) + 'Hash'), ', '
	, QUOTENAME(@FirstHub + 'Hash'), ', '
	, QUOTENAME(@SecondHub + 'Hash'), ', '
	,'CAST(S.RecordSource AS VARCHAR(50)) AS RecordSource, '
	,'CAST(S.ValidFrom AS DATETIME2(0)) AS ValidFrom', ' '
	,'FROM [DV].', QUOTENAME(@SourceObject + '_CTAS') , ' AS S; '
-- 32194 - SR - 02/02/2024 - Amended procedure to add drop CTAS table
	,'DROP TABLE [DV].' , QUOTENAME(@SourceObject + '_CTAS'), ';'
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
