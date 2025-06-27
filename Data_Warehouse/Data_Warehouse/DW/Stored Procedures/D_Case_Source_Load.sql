CREATE PROC [DW].[D_Case_Source_Load] AS


-- -------------------------------------------------------------------
-- Script:         DW.D_Case_Source Load
-- Target:         Azure Synapse Data Warehouse
-- -------------------------------------------------------------------

-- Delete temporary tables if present.

if object_id ('stg.DW_D_Case_Source_TEMP','U') is not null drop table stg.DW_D_Case_Source_TEMP;

-- -------------------------------------------------------------------
-- Create new table
-- -------------------------------------------------------------------

-- Get dataset from Landing Zone
CREATE TABLE stg.DW_D_Case_Source_TEMP
        with (clustered columnstore index, distribution = replicate)
AS

SELECT 
   -1 AS Case_Source_Skey,
   -1 AS CaseSourceBusKey,
	'Not Available' AS CaseSource,
   CAST(0 AS BIT) AS Active,
    '1900-1-1' AS Sys_LoadDate,
    '1900-1-1' AS Sys_ModifiedDate,
    -1 AS Sys_RunID

UNION

SELECT 
	cast(row_number() over (order by getdate()) as int) as [Case_Source_Skey],
	CaseSourceID AS [CaseSourceBusKey],
	[CaseSource],
	[Active],
	[Sys_LoadDate],
    [Sys_ModifiedDate],
    [Sys_RunID]
FROM DS.Case_Source

-- Create NOT NULL constraint on temp
alter table stg.DW_D_Case_Source_TEMP
ALTER COLUMN Case_Source_Skey INT NOT NULL

-- Create primary key on temp
alter table stg.DW_D_Case_Source_TEMP
ADD CONSTRAINT PK_DW_Case_Source PRIMARY KEY NONCLUSTERED (Case_Source_Skey) NOT ENFORCED

-- Switch table contents replacing target with temp.

alter table DW.[D_Case_Source] switch to OLD.DW_D_Case_Source with (truncate_target=on);
alter table stg.DW_D_Case_Source_TEMP switch to DW.[D_Case_Source] with (truncate_target=on);

drop table stg.DW_D_Case_Source_TEMP;

-- Force replication of table.

--select  * from DW.[D_Case_Source] order by 1;