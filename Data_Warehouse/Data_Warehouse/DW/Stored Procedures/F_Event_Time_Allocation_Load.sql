CREATE PROC [DW].[F_Event_Time_Allocation_Load] AS

-- -------------------------------------------------------------------
-- Script:         DW.F_Event_Time_Allocation Load
-- Target:         Azure Synapse Data Warehouse
-- -------------------------------------------------------------------

-- Delete temporary tables if present.

if object_id ('stg.DW_F_Event_Time_Allocation_TEMP','U')  is not null drop table stg.DW_F_Event_Time_Allocation_TEMP;
if object_id ('stg.DW_F_Event_Time_Allocation_TEMP1','U') is not null drop table stg.DW_F_Event_Time_Allocation_TEMP1;
if object_id ('stg.DW_F_Event_Time_Allocation_TEMP2','U') is not null drop table stg.DW_F_Event_Time_Allocation_TEMP2;

-- -------------------------------------------------------------------
-- First pass creates new versions of existing rows.
-- -------------------------------------------------------------------

-- Get dataset from Data Store
CREATE TABLE stg.DW_F_Event_Time_Allocation_TEMP
        WITH (clustered columnstore index, distribution = hash(EventTimeAllocationBusKey)) 
AS

SELECT
	ds_eta.EventTimeAllocationID					AS [EventTimeAllocationBusKey],
	COALESCE(dw_wfet.Work_Flow_Event_Type_Skey, -1) AS Work_Flow_Event_Type_Skey,
	COALESCE(dw_ep.Event_Plan_Skey, -1)				AS Event_Plan_Skey,
	COALESCE(ds_eta.EventTimeInSeconds,0)			AS EventTimeInSeconds,
	COALESCE(ds_eta.EventTimeInMinutes,0)			AS EventTimeInMinutes,
	ds_eta.Sys_LoadDate,
	ds_eta.Sys_RunID

FROM DS.[Event_Time_Allocation] ds_eta
		LEFT JOIN DW.D_Work_Flow_Event_Type dw_wfet 
			ON ds_eta.WorkFlowEventTypeID = dw_wfet.WorkFlowEventTypeBusKey
		LEFT JOIN DW.D_Event_Plan dw_ep 
			ON ds_eta.EventPlanID = dw_ep.EventPlanBusKey

-- Update Existing Rows
CREATE TABLE stg.DW_F_Event_Time_Allocation_TEMP1
        WITH (clustered columnstore index, distribution = hash(EventTimeAllocationBusKey)) as

SELECT
	dw.[Event_Time_Allocation_Skey],
	stg.[EventTimeAllocationBusKey],
	stg.Work_Flow_Event_Type_Skey,
	stg.Event_Plan_Skey,
	stg.EventTimeInSeconds,
	stg.EventTimeInMinutes,
	stg.Sys_LoadDate,
	stg.Sys_RunID
FROM stg.DW_F_Event_Time_Allocation_TEMP stg
	INNER JOIN DW.F_Event_Time_Allocation DW
		ON DW.EventTimeAllocationBusKey = stg.EventTimeAllocationBusKey

-- -------------------------------------------------------------------
-- Second pass appends new rows to table
-- -------------------------------------------------------------------

-- Copy current table .. note distribution to REPLICATE

create  table stg.DW_F_Event_Time_Allocation_TEMP2
        with (clustered columnstore index, distribution = hash(Work_Flow_Event_Type_Skey)) as

SELECT
	stg.[Event_Time_Allocation_Skey],
	stg.[EventTimeAllocationBusKey],
	stg.Work_Flow_Event_Type_Skey,
	stg.Event_Plan_Skey,
	stg.EventTimeInSeconds,
	stg.EventTimeInMinutes,
	stg.Sys_LoadDate,
	stg.Sys_RunID
FROM stg.DW_F_Event_Time_Allocation_TEMP1 stg

UNION ALL

-- Add new rows.
SELECT
	cast(COALESCE((select max(Event_Time_Allocation_Skey) from stg.DW_F_Event_Time_Allocation_TEMP1),0) + row_number() over (order by getdate()) as int) as [Event_Time_Allocation_Skey],
	stg.[EventTimeAllocationBusKey],
	stg.Work_Flow_Event_Type_Skey,
	stg.Event_Plan_Skey,
	stg.EventTimeInSeconds,
	stg.EventTimeInMinutes,
	stg.Sys_LoadDate,
	stg.Sys_RunID
from    stg.DW_F_Event_Time_Allocation_TEMP stg
        left outer join stg.DW_F_Event_Time_Allocation_TEMP1 stg_t1
        on stg_t1.EventTimeAllocationBusKey = stg.EventTimeAllocationBusKey
where   stg_t1.EventTimeAllocationBusKey is null

-- Create NOT NULL constraint on temp
alter table stg.DW_F_Event_Time_Allocation_TEMP2
ALTER COLUMN Event_Time_Allocation_Skey INT NOT NULL

-- Create primary key on temp
alter table stg.DW_F_Event_Time_Allocation_TEMP2
ADD CONSTRAINT PK_DW_F_Event_Time_Allocation PRIMARY KEY NONCLUSTERED (Event_Time_Allocation_Skey) NOT ENFORCED

---- Switch table contents replacing target with temp.

alter table DW.F_Event_Time_Allocation switch to OLD.DW_F_Event_Time_Allocation with (truncate_target=on);
alter table stg.DW_F_Event_Time_Allocation_TEMP2 switch to DW.F_Event_Time_Allocation with (truncate_target=on);

drop table stg.DW_F_Event_Time_Allocation_TEMP;
drop table stg.DW_F_Event_Time_Allocation_TEMP1;
drop table stg.DW_F_Event_Time_Allocation_TEMP2;

---- Force replication of table.
--select * from DW.[F_Event_Time_Allocation] order by 1;


--drop table DW.F_Event_Time_Allocation
--drop table OLD.DW_F_Event_Time_Allocation

--CREATE TABLE DW.F_Event_Time_Allocation
--        WITH (clustered columnstore index, distribution = hash(Work_Flow_Event_Type_Skey)) 
--AS
--select a.* from stg.DW_F_Event_Time_Allocation_TEMP2 a where 1=0

--CREATE TABLE OLD.DW_F_Event_Time_Allocation
--        WITH (clustered columnstore index, distribution = hash(Work_Flow_Event_Type_Skey)) 
--AS
--select a.* from stg.DW_F_Event_Time_Allocation_TEMP2 a where 1=0