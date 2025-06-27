CREATE PROC [DW].[D_Case_Complexity_Load] AS


-- -------------------------------------------------------------------
-- Script:         DW.D_Case_Complexity Load
-- Target:         Azure Synapse Data Warehouse
-- -------------------------------------------------------------------

-- Delete temporary tables if present.

if object_id ('stg.DW_D_Case_Complexity_TEMP','U') is not null drop table stg.DW_D_Case_Complexity_TEMP;

-- -------------------------------------------------------------------
-- Create new table
-- -------------------------------------------------------------------

-- Get dataset from Landing Zone
CREATE TABLE stg.DW_D_Case_Complexity_TEMP
        with (clustered columnstore index, distribution = replicate)
AS

SELECT 
	cast(row_number() over (order by getdate()) as int) as [Case_Complexity_Skey],
	[CaseComplexityBusKey],
	[CaseComplexity],
	[Active],
	[Sys_LoadDate],
    [Sys_ModifiedDate],
    [Sys_RunID]
FROM DS.Case_Complexity

-- Create NOT NULL constraint on temp
alter table stg.DW_D_Case_Complexity_TEMP
ALTER COLUMN Case_Complexity_Skey INT NOT NULL

-- Create primary key on temp
alter table stg.DW_D_Case_Complexity_TEMP
ADD CONSTRAINT PK_DW_Case_Complexity PRIMARY KEY NONCLUSTERED (Case_Complexity_Skey) NOT ENFORCED

-- Switch table contents replacing target with temp.

alter table DW.[D_Case_Complexity] switch to OLD.DW_D_Case_Complexity with (truncate_target=on);
alter table stg.DW_D_Case_Complexity_TEMP switch to DW.[D_Case_Complexity] with (truncate_target=on);

drop table stg.DW_D_Case_Complexity_TEMP;

-- Force replication of table.

--select  * from DW.[D_Case_Complexity] order by 1;
