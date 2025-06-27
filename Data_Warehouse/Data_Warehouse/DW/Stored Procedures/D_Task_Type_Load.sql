CREATE PROC [DW].[D_Task_Type_Load] AS


-- -------------------------------------------------------------------
-- Script:         DW.D_Task_Type Load
-- Target:         Azure Synapse Data Warehouse
-- -------------------------------------------------------------------

-- Delete temporary tables if present.

if object_id ('stg.DW_D_Task_Type_TEMP','U') is not null drop table stg.DW_D_Task_Type_TEMP;
if object_id ('stg.DW_D_Task_Type_TEMP1','U') is not null drop table stg.DW_D_Task_Type_TEMP1;
if object_id ('stg.DW_D_Task_Type_TEMP2','U') is not null drop table stg.DW_D_Task_Type_TEMP2;

-- -------------------------------------------------------------------
-- Create new table
-- -------------------------------------------------------------------

-- Get dataset from Landing Zone
CREATE TABLE stg.DW_D_Task_Type_TEMP
        with (clustered columnstore index, distribution = hash(TaskTypeBusKey))
AS

SELECT
	TaskTypeID AS TaskTypeBusKey,
	TaskType,
	Active,
	[Sys_LoadDate],
    [Sys_ModifiedDate],
    [Sys_RunID]
FROM DS.Task_Type tt 

-- Update Existing Rows
CREATE TABLE stg.DW_D_Task_Type_TEMP1
        WITH (clustered columnstore index, distribution = hash(TaskTypeBusKey)) as

SELECT
	DW.Task_Type_Skey,
	stg.TaskTypeBusKey,
	stg.TaskType,
	stg.Active,
	stg.[Sys_LoadDate],
    stg.[Sys_ModifiedDate],
    stg.[Sys_RunID]
FROM stg.DW_D_Task_Type_TEMP stg 
	INNER JOIN DW.D_Task_Type DW
		ON DW.TaskTypeBusKey = stg.TaskTypeBusKey

-- -------------------------------------------------------------------
-- Second pass appends new rows to table
-- -------------------------------------------------------------------

-- Copy current table .. note distribution to REPLICATE

create  table stg.DW_D_Task_Type_TEMP2
        with (clustered columnstore index, distribution = replicate) as

SELECT 
   -1 AS Task_Type_Skey,
   -1 AS TaskTypeBusKey,
	'Not Available' AS TaskType,
   CAST(0 AS BIT) AS Active,
    '1900-1-1' AS Sys_LoadDate,
    '1900-1-1' AS Sys_ModifiedDate,
    -1 AS Sys_RunID

UNION ALL

SELECT
	stg.Task_Type_Skey,
	stg.TaskTypeBusKey,
	stg.TaskType,
	stg.Active,
	stg.[Sys_LoadDate],
    stg.[Sys_ModifiedDate],
    stg.[Sys_RunID]
FROM stg.DW_D_Task_Type_TEMP1 stg 

UNION ALL

-- Add new rows.
SELECT
	cast(COALESCE((select max(Task_Type_Skey) from stg.DW_D_Task_Type_TEMP1),0) + row_number() over (order by getdate()) as int) as Task_Type_Skey,
	stg.TaskTypeBusKey,
	stg.TaskType,
	stg.Active,
	stg.[Sys_LoadDate],
    stg.[Sys_ModifiedDate],
    stg.[Sys_RunID]
FROM stg.DW_D_Task_Type_TEMP stg 
	LEFT OUTER JOIN stg.DW_D_Task_Type_TEMP1 stg_t1
	ON stg_t1.TaskTypeBusKey = stg.TaskTypeBusKey
where   stg_t1.TaskTypeBusKey is null

-- Create NOT NULL constraint on temp
alter table stg.DW_D_Task_Type_TEMP2
ALTER COLUMN Task_Type_Skey INT NOT NULL

-- Create primary key on temp
alter table stg.DW_D_Task_Type_TEMP2
ADD CONSTRAINT PK_DW_Task_Type PRIMARY KEY NONCLUSTERED (Task_Type_Skey) NOT ENFORCED

-- Switch table contents replacing target with temp.

alter table DW.[D_Task_Type] switch to OLD.DW_D_Task_Type with (truncate_target=on);
alter table stg.DW_D_Task_Type_TEMP2 switch to DW.[D_Task_Type] with (truncate_target=on);

drop table stg.DW_D_Task_Type_TEMP;
drop table stg.DW_D_Task_Type_TEMP1;
drop table stg.DW_D_Task_Type_TEMP2;

-- Force replication of table.

--select  * from DW.[D_Task_Type] order by 1;