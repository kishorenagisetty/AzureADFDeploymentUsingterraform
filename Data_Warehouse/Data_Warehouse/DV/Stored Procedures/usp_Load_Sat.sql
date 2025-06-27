CREATE PROC [DV].[usp_Load_Sat] @ObjectMappingID [INT],@Debug [BIT],@RecordSource [VARCHAR](MAX),@ADFRunId [UNIQUEIDENTIFIER] AS
BEGIN
-- ===============================================================
-- Author:	Shaz Rehman
-- Create date: 11/09/2023
-- Ticket Ref: #27457
-- Name: [DV].[usp_Load_Sat]
-- Description: Runs dynamic SQL to load in all Sat Tables
-- Revisions:
-- 32817 - SR - 19/02/2024 - Added ADF GUID ID to identify run and Record Source in Logging table
-- ===============================================================

--DECLARE @ObjectMappingID INT = 73
--DECLARE @Debug BIT = 0
--EXEC [DV].[usp_Load_Sat] @ObjectMappingID = 346, @PipelineRunID = 'N/A', @Debug = 1, @Method = 'CTAS'
SET NOCOUNT ON

	BEGIN TRY
	DECLARE @SourceSchema VARCHAR(100)
	DECLARE @SourceObject VARCHAR(100)
	DECLARE @Count INT = 0
	DECLARE @Message NVARCHAR(MAX)
	DECLARE @SQL NVARCHAR(MAX)
	DECLARE @RowsAffected INT = 0


	SELECT 
		@SourceSchema = SourceSchema,
		@SourceObject = SourceTable
	FROM ELT.DVObjectMapping WHERE ObjectMappingID = @ObjectMappingID

	DECLARE @HubName VARCHAR(100)
	SET @HubName = RIGHT(@SourceObject,LEN(@SourceObject)-4)
	SET @HubName = LEFT(@HubName, CHARINDEX('_',@HubName)-1)
	
	SET @Count = ISNULL(
		(SELECT COUNT(*) FROM sys.objects T INNER JOIN sys.schemas S ON S.schema_id = T.schema_id WHERE T.Type = 'U' and S.Name = 'DV' and T.Name = 'HUB_' + @HubName)
		,0)

	IF @Count = 0
	BEGIN
		SET @Message = 'Object: ' + QUOTENAME(@SourceSchema) +'.' + QUOTENAME(@SourceObject) + ': Associated Hub Table [DV].' + QUOTENAME('HUB_'+@HubName) + ' not found.'
		RAISERROR(@Message, 16, 0)
	END

	SET @Count = 0

	SELECT @Count = ISNULL(COUNT(*),0) 
	FROM sys.objects T INNER JOIN sys.schemas S ON S.schema_id = T.schema_id
	WHERE T.name = @SourceObject and S.Name = @SourceSchema

	IF @Count = 0
	BEGIN
		SET @Message = 'Object: ' + QUOTENAME(@SourceSchema) +'.' + QUOTENAME(@SourceObject) + ': SAT source object not found.'
		RAISERROR(@Message, 16, 0)
		--Source doesn't exist
	END

	--Check if target table exists
	SELECT @Count = ISNULL(COUNT(*),0) 
	FROM sys.objects T INNER JOIN sys.schemas S ON S.schema_id = T.schema_id
	WHERE T.name = @SourceObject and S.Name = 'DV' and T.Type = 'U'

	DECLARE @SatColumnsForHash NVARCHAR(MAX)
	DECLARE @SatColumns NVARCHAR(MAX)
	DECLARE @KeyColumn NVARCHAR(100)

	SET @KeyColumn = (
		SELECT TOP 1 C.Name FROM sys.objects V 
		INNER JOIN sys.schemas S ON S.schema_id = V.schema_id
		INNER JOIN sys.columns C ON C.object_id = V.object_id
		WHERE V.name = @SourceObject and S.Name = @SourceSchema
		ORDER BY C.Column_id)
		
	SET @SatColumns = (
	SELECT STRING_AGG(QUOTENAME(C.Name),', ') WITHIN GROUP (ORDER BY C.Column_id ASC ) 
	FROM sys.objects V 
	INNER JOIN sys.schemas S ON S.schema_id = V.schema_id
	INNER JOIN sys.columns C ON C.object_id = V.object_id
	WHERE V.name = @SourceObject and S.Name = @SourceSchema and C.Name NOT IN ('ValidFrom','ValidTo','IsCurrent') and C.Name <> @KeyColumn)

	SET @SatColumnsForHash = (
	SELECT 'HASHBYTES(''SHA2_256'',CONCAT_WS(''|'','''',' +
		STRING_AGG(CONCAT('ISNULL(CAST(',QUOTENAME(C.Name),' AS NVARCHAR(MAX)),'''')'),', ') WITHIN GROUP (ORDER BY C.Name ASC ) +
		'))'
	FROM sys.objects V 
	INNER JOIN sys.schemas S ON S.schema_id = V.schema_id
	INNER JOIN sys.columns C ON C.object_id = V.object_id
	WHERE V.name = @SourceObject and S.Name = @SourceSchema and C.Name NOT IN ('ValidFrom','ValidTo','IsCurrent') and C.Name <> @KeyColumn)

	IF @Count = 0
	BEGIN
		SET @SQL = 
		'CREATE TABLE DV.' + QUOTENAME(@SourceObject) +
		' WITH (HEAP, DISTRIBUTION=HASH([' + @HubName + 'Hash]))' + ' AS ' +
		'SELECT TOP 0 ' + 
		'CAST(NULL AS BINARY(32)) AS [' + @HubName + 'Hash], ' + 
		'CAST(NULL AS NVARCHAR(100)) AS [' + @HubName + 'Key], ' + 
		@SatColumns + ', ' +
		'CAST(NULL AS BINARY(32)) AS [ContentHash], ' + 
		'CAST(NULL AS DATETIME2(0)) AS [ValidFrom], ' + 
		'CAST(NULL AS DATETIME2(0)) AS [ValidTo], ' + 
		'CAST(NULL AS BIT) AS [IsCurrent] ' + 
		' FROM ' + QUOTENAME(@SourceSchema) + '.' + QUOTENAME(@SourceObject) 
		IF @Debug = 1
		BEGIN
			PRINT @SQL
		END
		ELSE
		BEGIN
			EXEC sp_executesql @SQL
		END	
	END

--#27457 SR 11/09/2023 -- This step is getting the refresh dates therefore now not required.
	--DECLARE @TargetMinValidFrom DATETIME2(0) = '19000101'
	--SET @SQL = 'SELECT @MD = ISNULL(MAX(ValidFrom),''19000101'') FROM DV.['+@SourceObject+']'
	--EXEC sp_executesql @SQL, N'@MD DATETIME2(0) OUTPUT', @MD = @TargetMinValidFrom OUTPUT
	
	--SET @SQL = CONCAT('
	--INSERT INTO #VersionsToLoad
	--SELECT ROW_NUMBER() OVER (ORDER BY ValidFrom ASC) AS UpdateLine, *
	--FROM (
	--	SELECT ValidFrom, CAST(NULL AS NVARCHAR(MAX)) AS SQL FROM ', QUOTENAME(@SourceSchema), '.', QUOTENAME(@SourceObject), ' ',
	--	'WHERE ValidFrom > ''', @TargetMinValidFrom, '''',
	--	'GROUP BY ValidFrom ) S'
	--)
	
	--IF OBJECT_ID('tempdb..#VersionsToLoad') IS NOT NULL
	--BEGIN
	--	DROP TABLE #VersionsToLoad
	--END
	--CREATE TABLE #VersionsToLoad (UpdateLine INT, ValidFrom DATETIME2(0), SQL NVARCHAR(MAX)) WITH (HEAP, DISTRIBUTION=ROUND_ROBIN)

	--EXEC sp_executesql @SQL

	--DECLARE @MaxValidFrom DATETIME2(0)
	--SET @MaxValidFrom = (SELECT MAX(ValidFrom) FROM #VersionsToLoad)
-- 

	IF OBJECT_ID('DV.' + @SourceObject + '_CTAS','U') IS NOT NULL
	BEGIN
	SET @SQL = 'DROP TABLE DV.' + @SourceObject + '_CTAS'
	EXEC sp_executesql @SQL
	END

--#27457 SR 11/09/2023  -- This is the new dynamic SQL build
	SET @SQL =  CONCAT(
	'CREATE TABLE DV.', QUOTENAME(@SourceObject+'_CTAS'), ' '
	, 'WITH (HEAP, DISTRIBUTION=HASH([', @HubName, 'Hash]))', ' AS '
	, 'WITH CurrentRecords AS ('
	, 'SELECT CAST(HASHBYTES(''SHA2_256'',CAST(',@KeyColumn,' AS NVARCHAR(MAX))) AS BINARY(32)) AS ', QUOTENAME(@HubName + 'Hash'), ', '
	, QUOTENAME(@KeyColumn), ' AS ', QUOTENAME(@HubName+'Key'), ', '
	, @SatColumns, ', '
	, 'CAST(', @SatColumnsForHash, ' AS BINARY(32)) AS ContentHash, '
	, 'ValidFrom AS ValidFrom, '
	, 'CAST(''9999-12-31 23:59:59'' AS DATETIME2(0)) AS ValidTo,'
	, 'CAST(1 AS BIT) AS IsCurrent'
	, ' FROM '
	, QUOTENAME(@SourceSchema), '.'
	, QUOTENAME(@SourceObject), ' AS S '
	,'WHERE S.IsCurrent = 1 '
	, ') '
	, 'SELECT ' 
	, QUOTENAME(@HubName + 'Hash'), ', '
	, QUOTENAME(@HubName+'Key'), ', '
	, @SatColumns, ', '
	, '[ContentHash], [ValidFrom],  [ValidTo], [IsCurrent] '
	, 'FROM CurrentRecords '
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

--#27457 SR 11/09/2023 -- This the the new auditing of the Dynamic SQL
	DECLARE @SQLCount NVARCHAR(MAX)
	DECLARE @RecCount BIGINT = 0

	SET @SQLCount = 'SELECT @COUNT = COUNT(1) FROM DV.['+@SourceObject + '_CTAS'+']'

	EXEC sp_executesql @SQLCount, N'@Count BIGINT OUTPUT', @Count = @RecCount OUTPUT

-- 32817 - SR - 19/02/2024 - Added ADF GUID ID to identify run: @ADFRunId
	EXEC [Logs].[usp_Exec_DSQL]
		 @p_SourceSystem = @RecordSource
	   , @p_Sproc = '[DV].[usp_Load_Sat]'
	   , @p_SQL = @SQL
	   , @p_RowCount = @RecCount
	   , @p_Comments = @SourceObject
	   , @p_CustomErr = NULL
	   , @p_ADFRunId = @ADFRunId --'f4adf4ec-f8ca-47a1-a36b-36a792cd1b5c'



/* --#27457 SR 11/09/2023 -- Old dynamic sql build now no longer required
	SET @SQL =  CONCAT(
	'CREATE TABLE DV.', QUOTENAME(@SourceObject+'_CTAS'), ' '
	, 'WITH (HEAP, DISTRIBUTION=HASH([', @HubName, 'Hash]))', ' AS '
	, 'WITH CurrentRecords AS ('
	, 'SELECT CAST(HASHBYTES(''SHA2_256'',CAST(',@KeyColumn,' AS NVARCHAR(MAX))) AS BINARY(32)) AS ', QUOTENAME(@HubName + 'Hash'), ', '
	, QUOTENAME(@KeyColumn), ' AS ', QUOTENAME(@HubName+'Key'), ', '
	, @SatColumns, ', '
	, 'CAST(', @SatColumnsForHash, ' AS BINARY(32)) AS ContentHash, '
	, 'ValidFrom AS ValidFrom, '
	, 'CAST(''9999-12-31 23:59:59'' AS DATETIME2(0)) AS ValidTo,'
	, 'CAST(1 AS BIT) AS IsCurrent'
	, ' FROM '
	, QUOTENAME(@SourceSchema), '.'
	, QUOTENAME(@SourceObject), ' AS S '
	, '{SourceFilters}'
	, ')'
	--'Keep Unaltered Records',
	, 'SELECT '
	, 'T.* '
	, 'FROM DV.', QUOTENAME(@SourceObject),' T '
	, 'LEFT JOIN CurrentRecords S ON S.', QUOTENAME(@HubName + 'Key'), ' = T.', QUOTENAME(@HubName + 'Key'), ' '
	, 'WHERE (T.IsCurrent = 1 AND T.ContentHash = S.ContentHash) OR T.IsCurrent = 0 OR S.', QUOTENAME(@HubName + 'Key'), ' IS NULL '
	, 'UNION ALL '
	--'Close off updated records',
	, 'SELECT '
	, 'T.',QUOTENAME(@HubName + 'Hash'), ', '
	, 'T.',QUOTENAME(@HubName + 'Key'), ', '
	, REPLACE(@SatColumns,'[','T.['), ', '
	, 'T.[ContentHash], '
	, 'T.[ValidFrom], '
	, 'ISNULL(S.[ValidFrom], GETUTCDATE()) AS [ValidTo], '
	, 'CAST(0 AS BIT) AS IsCurrent '
	, 'FROM DV.', QUOTENAME(@SourceObject),' T '
	, 'INNER JOIN CurrentRecords S ON S.', QUOTENAME(@HubName + 'Key'), ' = T.', QUOTENAME(@HubName + 'Key'), ' '
	, 'WHERE T.ContentHash <> S.ContentHash and T.IsCurrent = 1'
	, 'UNION ALL '
	--'Insert new records',
	, 'SELECT '
	, 'S.* ' 
	, 'FROM CurrentRecords S '
	, '	LEFT JOIN DV.', QUOTENAME(@SourceObject),' T ON S.', QUOTENAME(@HubName + 'Key'), ' = T.', QUOTENAME(@HubName + 'Key'), ' '
	, '	WHERE (T.IsCurrent = 1 AND T.ContentHash <> S.ContentHash) OR T.', QUOTENAME(@HubName + 'Key'), ' IS NULL '
	)
	UPDATE V SET SQL = 
		REPLACE(@SQL,'{SourceFilters}','WHERE ValidFrom = ''' + CAST(ValidFrom AS VARCHAR) + '''' + CASE WHEN ValidFrom = @MaxValidFrom THEN ' AND S.IsCurrent = 1 ' ELSE '' END)
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

		SET @SQL = 'DROP TABLE [DV].' + QUOTENAME(@sourceObject) + '; ' +
		'RENAME OBJECT [DV].' + QUOTENAME(@sourceObject + '_CTAS') + ' TO ' + QUOTENAME(@sourceObject)
		IF @Debug = 1
		BEGIN
			PRINT @SQL
		END
		ELSE
		BEGIN
			EXEC sp_executesql @SQL
		END

		SET @StatementBeingProcessed = @StatementBeingProcessed + 1
	END

*/

		SET @SQL = 'DROP TABLE [DV].' + QUOTENAME(@sourceObject) + '; ' +
		'RENAME OBJECT [DV].' + QUOTENAME(@sourceObject + '_CTAS') + ' TO ' + QUOTENAME(@sourceObject)
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