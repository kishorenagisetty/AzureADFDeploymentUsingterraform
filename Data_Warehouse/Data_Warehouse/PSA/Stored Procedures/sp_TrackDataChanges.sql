CREATE PROC [PSA].[sp_TrackDataChanges] @TrackDataChanges [INT] AS
BEGIN

	
DECLARE @SQLString NVARCHAR(MAX)
DECLARE @Columns VARCHAR(MAX)
DECLARE @HashColumns VARCHAR(MAX)
DECLARE @Source_Schema VARCHAR(10)
DECLARE @Table VARCHAR(100)
DECLARE @Stage_Schema VARCHAR(10)
DECLARE @Dest_Schema VARCHAR(10)
DECLARE @ID VARCHAR(100)
DECLARE @Key VARCHAR(100)

SELECT @Source_Schema = [Source_Schema],
	@Stage_Schema = [Stage_Schema],
	@Dest_Schema = [Dest_Schema],
	@Table = [Table],
	@ID = [ID],
	@Key= [Key]
FROM [ETL].[TrackDataChanges]
WHERE [TrackDataChangesID] = @TrackDataChanges

--SET @Source_Schema = 'LZ'
--SET @Stage_Schema = 'STG'
--SET @Dest_Schema = 'PSA'
--SET @Table = 'Restart_vBIRestart_Intervention_Service_Resources'
--SET @ID = 'iscr_intervention_service,iscr_resource'
--SET @Key = 'iscr_key'

IF @Source_Schema IS NOT NULL
BEGIN

	SET @SQLString = N'drop table '+@Stage_Schema+'.' + @Table + '_TEMP'

	if object_id (@Stage_Schema + '.' + @Table + '_TEMP','U') is not null 
		EXECUTE sp_executesql @SQLString

	SET @SQLString = N'drop table '+@Stage_Schema+'.' + @Table + '_TEMP1'

	if object_id (@Stage_Schema + '.' + @Table + '_TEMP1','U') is not null 
		EXECUTE sp_executesql @SQLString

	SET @SQLString = N'drop table '+@Stage_Schema+'.' + @Table + '_TEMP2'

	if object_id (@Stage_Schema + '.' + @Table + '_TEMP2','U') is not null 
		EXECUTE sp_executesql @SQLString


	SELECT @Columns = STRING_AGG(COLUMN_NAME,',') WITHIN GROUP (ORDER BY ORDINAL_POSITION)
	FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = @Table
	AND TABLE_SCHEMA = @Source_Schema

	SELECT @HashColumns = STRING_AGG('COALESCE(LTRIM(RTRIM('+COLUMN_NAME+')),'''')','+''|''+') WITHIN GROUP (ORDER BY ORDINAL_POSITION)
	FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = @Table
	AND TABLE_SCHEMA = @Source_Schema
	AND COLUMN_NAME <> 'SYS_LOADDATE'
	AND COLUMN_NAME <> 'SYS_RUNID'
	AND COLUMN_NAME <> 'SYS_BUSKEY'
	AND COLUMN_NAME <> @ID



	SET @COLUMNS += ',CAST(''9999-12-31'' AS DATETIME) AS [Sys_LoadExpiryDate],CAST(1 AS BIT) AS [Sys_IsCurrent], ' + CASE WHEN CHARINDEX(',',@ID) = 0 THEN @ID ELSE 'CONCAT_WS(''|'',' + @ID +')' END + ' AS Sys_BusKey' 

	--SELECT @COLUMNS

	--SELECT @HashColumns

	SET @SQLString = N'create  table '+@Stage_Schema+'.'+@Table+'_TEMP with (CLUSTERED INDEX (Sys_BusKey), distribution = hash(Sys_BusKey)) as'

	SET @SQLString += N' SELECT ' + @Columns + ',CAST(hashbytes(''MD5'','+@HashColumns+')  AS BINARY(16)) AS [Sys_HashKey] FROM ' + @Source_Schema + '.' + @Table

	--SELECT @SQLString

	EXECUTE sp_executesql @SQLString 

	IF OBJECT_ID(@Dest_Schema+'.'+@Table) IS NOT NULL
	BEGIN

	SELECT @Columns = STRING_AGG('t.'+COLUMN_NAME,',') WITHIN GROUP (ORDER BY ORDINAL_POSITION)
	FROM INFORMATION_SCHEMA.COLUMNS
	WHERE TABLE_NAME = @Table + '_TEMP'
	AND TABLE_SCHEMA = @Stage_Schema

SET @Columns = N'cast(ISNULL((select max('+@Key+') from '+@Dest_Schema+'.'+@Table+'),0) + row_number() over (order by getdate()) as int) as ' + @Key + ',' + @Columns

SET @SQLString = N'create  table '+@Stage_Schema+'.'+@Table+'_TEMP1 with (CLUSTERED INDEX (Sys_BusKey), distribution = hash(Sys_BusKey)) as'

--SET @SQLString = N''

SET @SQLString += N' SELECT ' + @Columns + ' FROM ' + @Stage_Schema + '.' + @Table + '_TEMP t'

SET @SQLString += N' INNER JOIN '+@Dest_Schema+'.'+@Table+' d on t.Sys_BusKey = d.Sys_BusKey WHERE d.Sys_Iscurrent = 1 AND t.Sys_HashKey <> d.Sys_HashKey'

SET @SQLString += N' UNION ALL '

SELECT @Columns = STRING_AGG('d.'+COLUMN_NAME,',') WITHIN GROUP (ORDER BY ORDINAL_POSITION)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = @Table + '_TEMP'
AND TABLE_SCHEMA = @Stage_Schema

SET @Columns = REPLACE(@Columns,',d.Sys_LoadExpiryDate',',case when t.Sys_BusKey is not null and d.Sys_Iscurrent = 1 then t.Sys_LoadDate else d.Sys_LoadExpiryDate end as Sys_LoadExpiryDate')

SET @Columns = REPLACE(@Columns,',d.Sys_IsCurrent',',CAST(case when t.Sys_BusKey is not null and d.Sys_IsCurrent = 1 then 0 else d.Sys_IsCurrent end AS BIT) as Sys_IsCurrent')

SET @SQLString += N' SELECT d.' + @key + ',' + @Columns + ' FROM ' + @Dest_Schema + '.' + @Table + ' d'

SET @SQLString += N' LEFT OUTER JOIN '+@Stage_Schema+'.'+@Table+'_TEMP t on t.Sys_BusKey = d.Sys_BusKey AND d.Sys_Iscurrent = 1 AND t.Sys_HashKey <> d.Sys_HashKey'

--SELECT @SQLString


EXECUTE sp_executesql @SQLString 
END
ELSE
BEGIN


	SELECT @Columns = STRING_AGG('t.'+COLUMN_NAME,',') WITHIN GROUP (ORDER BY ORDINAL_POSITION)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = @Table + '_TEMP'
AND TABLE_SCHEMA = @Stage_Schema

SET @Columns = N'cast(NULL as int) as ' + @Key + ',' + @Columns

SET @SQLString = N'create  table '+@Stage_Schema+'.'+@Table+'_TEMP1 with (CLUSTERED INDEX (Sys_BusKey), distribution = hash(Sys_BusKey)) as'

--SET @SQLString = N''

SET @SQLString += N' SELECT ' + @Columns + ' FROM ' + @Stage_Schema + '.' + @Table + '_TEMP t WHERE 1=2'

--SET @SQLString += N' INNER JOIN '+@Dest_Schema+'.'+@Table+' d on t.'+@ID+' = d.'+@ID+' WHERE d.Sys_Iscurrent = 1 AND t.Sys_HashKey <> d.Sys_HashKey'

----SET @SQLString += N' UNION ALL '

----SELECT @Columns = STRING_AGG('d.'+COLUMN_NAME,',') WITHIN GROUP (ORDER BY ORDINAL_POSITION)
----FROM INFORMATION_SCHEMA.COLUMNS
----WHERE TABLE_NAME = @Table + '_TEMP'
----AND TABLE_SCHEMA = @Stage_Schema

----SET @Columns = REPLACE(@Columns,',d.Sys_LoadExpiryDate',',case when t.CustomerID is not null and d.Sys_Iscurrent = 1 then t.Sys_LoadDate else d.Sys_LoadExpiryDate end as Sys_LoadExpiryDate')

----SET @Columns = REPLACE(@Columns,',d.Sys_IsCurrent',',CAST(case when t.CustomerID is not null and d.Sys_IsCurrent = 1 then 0 else d.Sys_IsCurrent end AS BIT) as Sys_IsCurrent')

----SET @SQLString += N' SELECT d.' + @key + ',' + @Columns + ' FROM ' + @Dest_Schema + '.' + @Table + ' d'

----SET @SQLString += N' LEFT OUTER JOIN '+@Stage_Schema+'.'+@Table+'_TEMP t on t.'+@ID+' = d.'+@ID+' AND d.Sys_Iscurrent = 1 AND t.Sys_HashKey <> d.Sys_HashKey'

--SELECT @SQLString


EXECUTE sp_executesql @SQLString 




END





SELECT @Columns = STRING_AGG('t1.'+COLUMN_NAME,',') WITHIN GROUP (ORDER BY ORDINAL_POSITION)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = @Table + '_TEMP1'
AND TABLE_SCHEMA = @Stage_Schema

--SET @Columns = N'cast(ISNULL((select max('+@Key+') from '+@Dest_Schema+'.'+@Table+'),0) + row_number() over (order by getdate()) as int) as ' + @Key + ',' + @Columns

SET @SQLString = N'create  table '+@Stage_Schema+'.'+@Table+'_TEMP2 with (CLUSTERED INDEX (Sys_BusKey), distribution = hash(Sys_BusKey)) as'

--SET @SQLString = N''

SET @SQLString += N' SELECT ' + @Columns + ' FROM ' + @Stage_Schema + '.' + @Table + '_TEMP1 t1'

SET @SQLString += N' UNION ALL '

--SET @Columns = N'cast(ISNULL((select max('+@Key+') from '+@Dest_Schema+'.'+@Table+'),0) + row_number() over (order by getdate()) as int) as ' + @Key + ',' + @Columns

SELECT @Columns = STRING_AGG('t.'+COLUMN_NAME,',') WITHIN GROUP (ORDER BY ORDINAL_POSITION)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = @Table + '_TEMP1'
AND TABLE_SCHEMA = @Stage_Schema


SET @Columns = REPLACE(@Columns,'t.' + @key,'cast(COALESCE((select max('+@key+') from '+@Stage_Schema+'.'+@Table+'_TEMP1),0) + row_number() over (order by getdate()) as int) as ' + @key)

SET @SQLString += N' SELECT ' + @Columns + ' FROM ' + @Stage_Schema + '.' + @Table + '_TEMP t'



SET @SQLString += N' LEFT OUTER JOIN '+@Stage_Schema+'.'+@Table+'_TEMP1 d on t.Sys_BusKey = d.Sys_BusKey WHERE d.Sys_BusKey is null'

--SELECT @SQLString

EXECUTE sp_executesql @SQLString 


-- Create NOT NULL constraint on temp
SET @SQLString = N'alter table '+@Stage_Schema+'.'+@Table+'_TEMP2'
SET @SQLString += N' ALTER COLUMN '+@Key+' INT NOT NULL'
EXECUTE sp_executesql @SQLString 


-- Create primary key on temp
SET @SQLString = N'alter table '+@Stage_Schema+'.'+@Table+'_TEMP2'
SET @SQLString += N' ADD CONSTRAINT PK_'+@Dest_Schema+'_'+@Table+' PRIMARY KEY NONCLUSTERED ('+@key+') NOT ENFORCED'
EXECUTE sp_executesql @SQLString 

-- Switch table contents replacing target with temp.

	IF OBJECT_ID(@Dest_Schema+'.'+@Table) IS NULL
	BEGIN

		SET @SQLString = N'CREATE TABLE '+@Dest_Schema+'.'+@Table+' with (CLUSTERED INDEX (Sys_BusKey), distribution = hash(Sys_BusKey)) as SELECT * FROM '+@Stage_Schema+'.'+@Table+'_TEMP2 WHERE 1=2'
		EXECUTE sp_executesql @SQLString 

	END


SET @SQLString = N'alter table '+@Stage_Schema+'.'+@Table+'_TEMP2 switch to '+@Dest_Schema+'.'+@Table+' with (truncate_target=on)'
EXECUTE sp_executesql @SQLString 

SET @SQLString = N'drop table '+@Stage_Schema+'.'+@Table+'_TEMP'
EXECUTE sp_executesql @SQLString 

SET @SQLString = N'drop table '+@Stage_Schema+'.'+@Table+'_TEMP1'
EXECUTE sp_executesql @SQLString 

SET @SQLString = N'drop table '+@Stage_Schema+'.'+@Table+'_TEMP2'
EXECUTE sp_executesql @SQLString 






END


END