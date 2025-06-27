CREATE PROC [DW].[D_Source_Load] AS


-- -------------------------------------------------------------------
-- Script:         DW.D_Source Load
-- Target:         Azure Synapse Data Warehouse
-- -------------------------------------------------------------------

-- Delete temporary tables if present.

if object_id ('stg.DW_D_Source_TEMP','U') is not null drop table stg.DW_D_Source_TEMP;
if object_id ('stg.DW_D_Source_TEMP1','U') is not null drop table stg.DW_D_Source_TEMP1;
if object_id ('stg.DW_D_Source_TEMP2','U') is not null drop table stg.DW_D_Source_TEMP2;

-- -------------------------------------------------------------------
-- First pass creates new versions of changing rows.
-- -------------------------------------------------------------------

-- Get dataset from Landing Zone
CREATE TABLE stg.DW_D_Source_TEMP
        with (clustered columnstore index, distribution = hash(SourceBusKey))
AS

SELECT 
	SourceID AS [SourceBusKey],
	[Source],
	[Active],
	[Sys_LoadDate],
    [Sys_ModifiedDate],
    [Sys_RunID]
FROM DS.[Source]

-- Update Existing Rows
CREATE TABLE stg.DW_D_Source_TEMP1
        WITH (clustered columnstore index, distribution = hash(SourceBusKey)) as

SELECT 
	dw.[Source_Skey],
	stg.[SourceBusKey],
	stg.[Source],
	stg.[Active],
	stg.[Sys_LoadDate],
    stg.[Sys_ModifiedDate],
    stg.[Sys_RunID]
FROM stg.DW_D_Source_TEMP stg
	INNER JOIN DW.D_Source DW
		ON DW.SourceBusKey = stg.SourceBusKey

-- -------------------------------------------------------------------
-- Second pass appends new rows to table
-- -------------------------------------------------------------------

-- Copy current table .. note distribution to REPLICATE

create  table stg.DW_D_Source_TEMP2
        with (clustered columnstore index, distribution = replicate) as

SELECT 
   -1 AS Source_Skey,
   -1 AS SourceBusKey,
	'Not Available' AS [Source],
   CAST(0 AS BIT) AS Active,
    '1900-1-1' AS Sys_LoadDate,
    '1900-1-1' AS Sys_ModifiedDate,
    -1 AS Sys_RunID

UNION ALL

SELECT 
	stg.[Source_Skey],
	stg.[SourceBusKey],
	stg.[Source],
	stg.[Active],
	stg.[Sys_LoadDate],
    stg.[Sys_ModifiedDate],
    stg.[Sys_RunID]
FROM stg.DW_D_Source_TEMP1 stg

UNION ALL

SELECT 
	cast(COALESCE((select max(Source_Skey) from stg.DW_D_Source_TEMP1),0) + row_number() over (order by getdate()) as int) as [Source_Skey],
	stg.[SourceBusKey],
	stg.[Source],
	stg.[Active],
	stg.[Sys_LoadDate],
    stg.[Sys_ModifiedDate],
    stg.[Sys_RunID]
FROM stg.DW_D_Source_TEMP stg
        left outer join stg.DW_D_Source_TEMP1 stg_t1
        on stg_t1.SourceBusKey = stg.SourceBusKey
where   stg_t1.SourceBusKey is null


-- Create NOT NULL constraint on temp
alter table stg.DW_D_Source_TEMP2
ALTER COLUMN Source_Skey INT NOT NULL

-- Create primary key on temp
alter table stg.DW_D_Source_TEMP2
ADD CONSTRAINT PK_DW_Source PRIMARY KEY NONCLUSTERED (Source_Skey) NOT ENFORCED

-- Switch table contents replacing target with temp.

alter table DW.[D_Source] switch to OLD.DW_D_Source with (truncate_target=on);
alter table stg.DW_D_Source_TEMP2 switch to DW.[D_Source] with (truncate_target=on);

drop table stg.DW_D_Source_TEMP;
drop table stg.DW_D_Source_TEMP1;
drop table stg.DW_D_Source_TEMP2;

-- Force replication of table.

--select  * from DW.[D_Source] order by 1;