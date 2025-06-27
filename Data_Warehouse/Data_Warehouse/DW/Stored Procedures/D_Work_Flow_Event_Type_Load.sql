CREATE PROC [DW].[D_Work_Flow_Event_Type_Load] AS


-- -------------------------------------------------------------------
-- Script:         DW.D_Work_Flow_Event_Type Load
-- Target:         Azure Synapse Data Warehouse
-- -------------------------------------------------------------------

-- Delete temporary tables if present.

if object_id ('stg.DW_D_Work_Flow_Event_Type_TEMP','U') is not null drop table stg.DW_D_Work_Flow_Event_Type_TEMP;
if object_id ('stg.DW_D_Work_Flow_Event_Type_TEMP1','U') is not null drop table stg.DW_D_Work_Flow_Event_Type_TEMP1;
if object_id ('stg.DW_D_Work_Flow_Event_Type_TEMP2','U') is not null drop table stg.DW_D_Work_Flow_Event_Type_TEMP2;

-- -------------------------------------------------------------------
-- First pass creates new versions of existing rows.
-- -------------------------------------------------------------------

-- Get dataset from Data Store
CREATE TABLE stg.DW_D_Work_Flow_Event_Type_TEMP
        with (clustered columnstore index, distribution = hash(WorkFlowEventTypeBusKey))
AS

SELECT
        [WorkFlowEventTypeID]									AS [WorkFlowEventTypeBusKey]
      , COALESCE(NULLIF([WorkFlowEventType],''),'Not Set')		AS [WorkFlowEventType]
      , COALESCE([WorkFlowEventID],0)							AS [EventID]
      --,[WorkFlowEventSequence]
      , COALESCE([WorkFlowPreviousEventID],0)					AS [PreviousEventID]
      , COALESCE(NULLIF([WorkFlowEventSLAType],''),'Not Set')	AS [WorkFlowEventSLAType]
	  , COALESCE([WorkFlowEventSLADurationType],'Not Set')		AS [WorkFlowEventSLADurationType]
      , COALESCE([WorkFlowEventSLADuration],0)					AS [WorkFlowEventSLADuration]
      --,[WorkFlowEventActionType]
      --,[WorkFlowSLAName]
      --,[WorkFlowTaskName]
      --,[WorkFlowEventAppointmentType]
      , COALESCE([MonthlyActivityType],'Not Set')				AS [MonthlyActivityType]
	  , COALESCE([SkippableEventID],0)							AS [SkippableEventID]
      , [Sys_LoadDate]
      , [Sys_ModifiedDate]
      , [Sys_RunID]
FROM [DS].[Work_Flow_Event_Type]
OPTION (LABEL = 'CTAS : Load [DW].[D_Work_Flow_Event_Type]')
;

-- Update Existing Rows
CREATE TABLE stg.DW_D_Work_Flow_Event_Type_TEMP1
        WITH (clustered columnstore index, distribution = hash(WorkFlowEventTypeBusKey)) as

SELECT
	     dw.[Work_Flow_Event_Type_Skey] 
      , stg.[WorkFlowEventTypeBusKey]
      , stg.[WorkFlowEventType]
      , stg.[EventID]
      , stg.[PreviousEventID]
      , stg.[WorkFlowEventSLAType]
	  , stg.[WorkFlowEventSLADurationType]
      , stg.[WorkFlowEventSLADuration]
      , stg.[MonthlyActivityType]
	  , stg.[SkippableEventID]
      , stg.[Sys_LoadDate]
      , stg.[Sys_ModifiedDate]
      , stg.[Sys_RunID]
FROM stg.DW_D_Work_Flow_Event_Type_TEMP stg
	INNER JOIN DW.D_Work_Flow_Event_Type DW
		ON DW.WorkFlowEventTypeBusKey = stg.WorkFlowEventTypeBusKey

-- -------------------------------------------------------------------
-- Second pass appends new rows to table
-- -------------------------------------------------------------------

-- Copy current table .. note distribution to REPLICATE

create  table stg.DW_D_Work_Flow_Event_Type_TEMP2
        with (clustered columnstore index, distribution = replicate) as

SELECT
	  -1				AS [Work_Flow_Event_Type_Skey] 
    , -1				AS [WorkFlowEventTypeBusKey]
    , 'Not Available'	AS [WorkFlowEventType]
    , -1				AS [EventID]
    , -1				AS [PreviousEventID]
    , 'Not Available'	AS [WorkFlowEventSLAType]
	, 'Not Available'	AS [WorkFlowEventSLADurationType]
    , -1				AS [WorkFlowEventSLADuration]
    , 'Not Available'	AS [MonthlyActivityType]
	, -1				AS [SkippableEventID]
	, '1900-1-1'		AS Sys_LoadDate
    , '1900-1-1'		AS Sys_ModifiedDate
	, -1				AS Sys_RunID

UNION ALL

SELECT
	    stg.[Work_Flow_Event_Type_Skey] 
      , stg.[WorkFlowEventTypeBusKey]
      , stg.[WorkFlowEventType]
      , stg.[EventID]
      , stg.[PreviousEventID]
      , stg.[WorkFlowEventSLAType]
	  , stg.[WorkFlowEventSLADurationType]
      , stg.[WorkFlowEventSLADuration]
      , stg.[MonthlyActivityType]
	  , stg.[SkippableEventID]
      , stg.[Sys_LoadDate]
      , stg.[Sys_ModifiedDate]
      , stg.[Sys_RunID]
FROM stg.DW_D_Work_Flow_Event_Type_TEMP1 stg

UNION ALL

-- Add new rows.
select	cast(COALESCE((select max(Work_Flow_Event_Type_Skey) from stg.DW_D_Work_Flow_Event_Type_TEMP1),0) + row_number() over (order by getdate()) as int) as [Work_Flow_Event_Type_Skey] 
      , stg.[WorkFlowEventTypeBusKey]
      , stg.[WorkFlowEventType]
      , stg.[EventID]
      , stg.[PreviousEventID]
      , stg.[WorkFlowEventSLAType]
	  , stg.[WorkFlowEventSLADurationType]
      , stg.[WorkFlowEventSLADuration]
      , stg.[MonthlyActivityType]
	  , stg.[SkippableEventID]
      , stg.[Sys_LoadDate]
      , stg.[Sys_ModifiedDate]
      , stg.[Sys_RunID]
from    stg.DW_D_Work_Flow_Event_Type_TEMP stg
        left outer join stg.DW_D_Work_Flow_Event_Type_TEMP1 stg_t1
        on stg_t1.WorkFlowEventTypeBusKey = stg.WorkFlowEventTypeBusKey
where   stg_t1.WorkFlowEventTypeBusKey is null

-- Create NOT NULL constraint
alter table [STG].[DW_D_Work_Flow_Event_Type_TEMP2]
ALTER COLUMN Work_Flow_Event_Type_Skey INT NOT NULL

-- Create primary key 
 ALTER TABLE [STG].[DW_D_Work_Flow_Event_Type_TEMP2]
 ADD CONSTRAINT PK_Work_Flow_Event_Type_Skey PRIMARY KEY NONCLUSTERED (Work_Flow_Event_Type_Skey) NOT ENFORCED

-- Switch table contents replacing target with temp.

alter table DW.[D_Work_Flow_Event_Type] switch to OLD.DW_D_Work_Flow_Event_Type with (truncate_target=on);
alter table stg.DW_D_Work_Flow_Event_Type_TEMP2 switch to DW.[D_Work_Flow_Event_Type] with (truncate_target=on);

drop table stg.DW_D_Work_Flow_Event_Type_TEMP;
drop table stg.DW_D_Work_Flow_Event_Type_TEMP1;
drop table stg.DW_D_Work_Flow_Event_Type_TEMP2;

-- Force replication of table.

--select  * from DW.[D_Work_Flow_Event_Type] order by 1;
