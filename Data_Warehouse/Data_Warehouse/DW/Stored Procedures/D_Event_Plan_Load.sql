CREATE PROC [DW].[D_Event_Plan_Load] AS


-- -------------------------------------------------------------------
-- Script:         DW.D_Event_Plan Load
-- Target:         Azure Synapse Data Warehouse
-- -------------------------------------------------------------------

-- Delete temporary tables if present.

if object_id ('stg.DW_D_Event_Plan_TEMP','U')  is not null drop table stg.DW_D_Event_Plan_TEMP;
if object_id ('stg.DW_D_Event_Plan_TEMP1','U') is not null drop table stg.DW_D_Event_Plan_TEMP1;
if object_id ('stg.DW_D_Event_Plan_TEMP2','U') is not null drop table stg.DW_D_Event_Plan_TEMP2;

-- -------------------------------------------------------------------
-- Create new table
-- -------------------------------------------------------------------

-- Get dataset from Landing Zone
CREATE TABLE stg.DW_D_Event_Plan_TEMP
        with (clustered columnstore index, distribution = hash(EventPlanBusKey))
AS

SELECT
	EventPlanID AS EventPlanBusKey,
	EventPlanDescription,
	[Sys_LoadDate],
    [Sys_ModifiedDate],
    [Sys_RunID]
FROM DS.Event_Plan ep  

-- Update Existing Rows
CREATE TABLE stg.DW_D_Event_Plan_TEMP1
        WITH (clustered columnstore index, distribution = hash(EventPlanBusKey)) as

SELECT
	[DW].Event_Plan_Skey,
	[stg].[EventPlanBusKey],
	[stg].[EventPlanDescription],
	[stg].[Sys_LoadDate],
    [stg].[Sys_ModifiedDate],
    [stg].[Sys_RunID]
FROM stg.DW_D_Event_Plan_TEMP stg 
	INNER JOIN DW.D_Event_Plan DW
		ON DW.EventPlanBusKey = stg.EventPlanBusKey

-- -------------------------------------------------------------------
-- Second pass appends new rows to table
-- -------------------------------------------------------------------

-- Copy current table .. note distribution to REPLICATE

create  table stg.DW_D_Event_Plan_TEMP2
        with (clustered columnstore index, distribution = replicate) as

SELECT 
   -1 AS Event_Plan_Skey,
   -1 AS EventPlanBusKey,
	'Not Available' AS EventPlanDescription,
    '1900-1-1' AS Sys_LoadDate,
    '1900-1-1' AS Sys_ModifiedDate,
    -1 AS Sys_RunID

UNION ALL

SELECT
	stg.Event_Plan_Skey,
	stg.EventPlanBusKey,
	stg.EventPlanDescription,
	stg.[Sys_LoadDate],
    stg.[Sys_ModifiedDate],
    stg.[Sys_RunID]
FROM stg.DW_D_Event_Plan_TEMP1 stg 

UNION ALL

-- Add new rows.
SELECT
	cast(COALESCE((select max(Event_Plan_Skey) from stg.DW_D_Event_Plan_TEMP1),0) + row_number() over (order by getdate()) as int) as Event_Plan_Skey,
	stg.EventPlanBusKey,
	stg.EventPlanDescription,
	stg.[Sys_LoadDate],
    stg.[Sys_ModifiedDate],
    stg.[Sys_RunID]
FROM stg.DW_D_Event_Plan_TEMP stg 
	LEFT OUTER JOIN stg.DW_D_Event_Plan_TEMP1 stg_t1
	ON stg_t1.EventPlanBusKey = stg.EventPlanBusKey
where   stg_t1.EventPlanBusKey is null

-- Create NOT NULL constraint on temp
alter table stg.DW_D_Event_Plan_TEMP2
ALTER COLUMN Event_Plan_Skey INT NOT NULL

-- Create primary key on temp
alter table stg.DW_D_Event_Plan_TEMP2
ADD CONSTRAINT PK_DW_Event_Plan PRIMARY KEY NONCLUSTERED (Event_Plan_Skey) NOT ENFORCED

-- Switch table contents replacing target with temp.

alter table DW.[D_Event_Plan] switch to OLD.DW_D_Event_Plan with (truncate_target=on);
alter table stg.DW_D_Event_Plan_TEMP2 switch to DW.[D_Event_Plan] with (truncate_target=on);

drop table stg.DW_D_Event_Plan_TEMP;
drop table stg.DW_D_Event_Plan_TEMP1;
drop table stg.DW_D_Event_Plan_TEMP2;

-- Force replication of table.

--select  * from DW.[D_Event_Plan] order by 2;

--CREATE TABLE DW.D_Event_Plan
--        with (clustered columnstore index, distribution = replicate) as
--SELECT 1 AS Event_Plan_Skey, a.* FROM stg.DW_D_Event_Plan_TEMP a WHERE 1=0

--CREATE TABLE OLD.DW_D_Event_Plan
--        with (clustered columnstore index, distribution = replicate) as
--SELECT 1 AS Event_Plan_Skey, a.* FROM stg.DW_D_Event_Plan_TEMP a WHERE 1=0