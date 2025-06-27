CREATE PROC [DW].[LNK_Work_Flow_Event_Analysis_Load] AS


-- -------------------------------------------------------------------
-- Script:         DW.LNK_Work_Flow_Event_Analysis Load
-- Target:         Azure Synapse Data Warehouse
-- -------------------------------------------------------------------

-- Delete temporary tables if present.

if object_id ('stg.DW_LNK_Work_Flow_Event_Analysis_TEMP','U') IS NOT NULL drop table stg.DW_LNK_Work_Flow_Event_Analysis_TEMP;
if object_id ('stg.DW_LNK_Work_Flow_Event_Analysis_TEMP1','U') IS NOT NULL drop table stg.DW_LNK_Work_Flow_Event_Analysis_TEMP1;
if object_id ('stg.DW_LNK_Work_Flow_Event_Analysis_TEMP2','U') IS NOT NULL drop table stg.DW_LNK_Work_Flow_Event_Analysis_TEMP2;

---- -------------------------------------------------------------------
---- First pass creates new versions of existing rows.
---- -------------------------------------------------------------------

---- Get dataset from Data Store
CREATE TABLE stg.DW_LNK_Work_Flow_Event_Analysis_TEMP
        WITH (clustered columnstore index, distribution = hash(Case_Analysis_Skey)) 
AS

SELECT
      COALESCE(f_ca.Case_Analysis_Skey, -1) AS Case_Analysis_Skey
	, COALESCE(dw_stg.Stage_Skey, -1) AS WorkFlowStages_Skey 
	, COALESCE(dw_wfet.Work_Flow_Event_Type_Skey, -1) AS WorkFlowEventType_Skey
	, COALESCE(CAST(format(ds_wfe.EventDate,'yyyyMMdd') AS INT), -1) AS WorkFlowEventDate_Skey
	, COALESCE(dw_time_event.Time_Skey, -1) AS WorkFlowEventTime_Skey
	, COALESCE(CAST(format(ds_wfe.EventEstimatedStartDate,'yyyyMMdd') AS INT), -1) AS WorkFlowEstimatedStartDate_Skey
	, COALESCE(dw_time_est_st.Time_Skey, -1) AS WorkFlowEstimatedStartTime_Skey
	, COALESCE(CAST(format(ds_wfe.EventEstimatedEndDate,'yyyyMMdd') AS INT), -1) AS WorkFlowEstimatedEndDate_Skey
	, COALESCE(dw_time_est_end.Time_Skey, -1) AS WorkFlowEstimatedEndTime_Skey
	, COALESCE(CAST(format(ds_wfe.EventOriginalStartDate,'yyyyMMdd') AS INT), -1) AS WorkFlowOriginalStartDate_Skey
	, COALESCE(dw_time_orig_st.Time_Skey, -1) AS WorkFlowOriginalStartTime_Skey
	, COALESCE(CAST(format(ds_wfe.EventEndDate,'yyyyMMdd') AS INT), -1) AS WorkFlowEndDate_Skey
	, COALESCE(dw_time_end.Time_Skey, -1) AS WorkFlowEndTime_Skey
	, COALESCE(dw_emp.Employee_Skey, -1) AS WorkFlowEventEmployee_Skey
	, COALESCE(dw_emp_hist.EmployeeHistory_Skey, -1) AS WorkFlowEventEmployeeHistory_Skey
	, dw_stg.StageOrder
	,1 as EventCount
    , CASE 
		 WHEN eventdate IS NOT NULL THEN 0  ELSE 1 
	  END AS EventOutstandingCount
    , CASE 
		 WHEN eventdate IS NOT NULL THEN 1 ELSE 0 
	  END AS EventCompletedCount
    , CASE 
		 WHEN eventdate IS NULL
              and EventEstimatedEndDate IS NOT NULL
              and CAST(GETDATE() AS DATE) > CAST(EventEstimatedEndDate AS DATE) THEN 1 
		 ELSE 0 
	  END AS EventOverDueCount
    , CASE 
		WHEN eventdate IS NOT NULL
             and EventEstimatedStartDate IS NOT NULL
             and CAST(eventdate AS DATE) <= CAST(EventEstimatedEndDate AS DATE)  THEN 1
        WHEN eventdate IS NOT NULL
             and  EventEstimatedEndDate IS NULL  THEN 1
        ELSE 0 
	  END AS EventCompletedWithinSLACount
    , CASE 
		WHEN eventdate IS NOT NULL
                 and EventEstimatedEndDate IS NOT NULL
                 and CAST(eventdate AS DATE) > CAST(EventEstimatedEndDate AS DATE)  THEN 1
        WHEN eventdate IS NOT NULL
             and  EventEstimatedEndDate IS NULL  THEN 0
        ELSE 0 
	  END AS EventCompletedOutsideSLACount
	, ds_wfe.EventSkippedCount
	, ds_wfe.Sys_LoadDate
	, ds_wfe.Sys_ModifiedDate
	, ds_wfe.Sys_RunID
FROM	
	DS.Work_Flow_Events ds_wfe
		INNER JOIN DS.Work_Flow_Event_Type ds_wfet
			ON ds_wfe.WorkFlowEventTypeID = ds_wfet.WorkFlowEventTypeID
		INNER JOIN DS.[Cases] ds_case
			ON ds_wfe.CaseID = ds_case.CaseID 
		LEFT JOIN DS.Employee_History ds_emp_hist
			ON ds_wfe.EVentEmployeeID = ds_emp_hist.EmployeeID
			AND ds_wfe.EventDate BETWEEN ds_emp_hist.[Start] AND ds_emp_hist.[End]
		LEFT JOIN DW.D_Work_Flow_Event_Type dw_wfet
			ON ds_wfet.WorkFlowEventTypeID = dw_wfet.WorkFlowEventTypeBusKey
		LEFT JOIN DW.D_Stage dw_stg
			ON ds_wfet.WorkFlowStageID = dw_stg.StageBusKey
		LEFT JOIN DW.D_Case dw_case
			ON ds_wfe.CaseID = dw_case.CaseBusKey
		LEFT JOIN DW.D_Employee dw_emp
			ON ds_wfe.EventEmployeeID = dw_emp.EmployeeBusKey
		LEFT JOIN DW.D_Employee_History dw_emp_hist
			ON ds_emp_hist.EmployeeHistoryID = dw_emp_hist.EmployeeHistoryBusKey
		LEFT JOIN DW.F_Case_Analysis f_ca
			ON dw_case.Case_Skey = f_ca.Case_Skey
		LEFT JOIN DW.D_Time dw_time_event 
			ON convert(time,ds_wfe.EventDate) = dw_time_event.[Time]
		LEFT JOIN DW.D_Time dw_time_est_st 
			ON convert(time,ds_wfe.EventEstimatedStartDate) = dw_time_est_st.[Time]
		LEFT JOIN DW.D_Time dw_time_est_end 
			ON convert(time,ds_wfe.EventEstimatedEndDate) = dw_time_est_end.[Time]			
		LEFT JOIN DW.D_Time dw_time_orig_st 
			ON convert(time,ds_wfe.EventOriginalStartDate) = dw_time_orig_st.[Time]
		LEFT JOIN DW.D_Time dw_time_end 
			ON convert(time,ds_wfe.EventEndDate) = dw_time_end.[Time]	
WHERE
	ds_case.ProviderID <> 208
	AND ds_case.Active = 1

-- Update Existing Rows
CREATE TABLE stg.DW_LNK_Work_Flow_Event_Analysis_TEMP1
        WITH (clustered columnstore index, distribution = hash(Case_Analysis_Skey)) as

SELECT  DW.[Work_Flow_Events_Skey]
	  ,stg.[Case_Analysis_Skey]
      ,stg.[WorkFlowStages_Skey]
      ,stg.[WorkFlowEventType_Skey]
      ,stg.[WorkFlowEventDate_Skey]
      ,stg.[WorkFlowEventTime_Skey]
      ,stg.[WorkFlowEstimatedStartDate_Skey]
      ,stg.[WorkFlowEstimatedStartTime_Skey]
      ,stg.[WorkFlowEstimatedEndDate_Skey]
      ,stg.[WorkFlowEstimatedEndTime_Skey]
      ,stg.[WorkFlowOriginalStartDate_Skey]
      ,stg.[WorkFlowOriginalStartTime_Skey]
      ,stg.[WorkFlowEndDate_Skey]
      ,stg.[WorkFlowEndTime_Skey]
      ,stg.[WorkFlowEventEmployee_Skey]
      ,stg.[WorkFlowEventEmployeeHistory_Skey]
      ,stg.[StageOrder]
      ,stg.[EventCount]
      ,stg.[EventOutstandingCount]
      ,stg.[EventCompletedCount]
      ,stg.[EventOverDueCount]
      ,stg.[EventCompletedWithinSLACount]
      ,stg.[EventCompletedOutsideSLACount]
	  ,stg.[EventSkippedCount]
      ,stg.[Sys_LoadDate]
      ,stg.[Sys_ModifiedDate]
      ,stg.[Sys_RunID]
FROM stg.DW_LNK_Work_Flow_Event_Analysis_TEMP stg
	INNER JOIN DW.LNK_Work_Flow_Event_Analysis DW
		ON DW.Case_Analysis_Skey = stg.Case_Analysis_Skey
		AND DW.[WorkFlowEventType_Skey] = stg.[WorkFlowEventType_Skey]

---- -------------------------------------------------------------------
---- Second pass appends new rows to table
---- -------------------------------------------------------------------

---- Copy current table .. note distribution to REPLICATE

create  table stg.DW_LNK_Work_Flow_Event_Analysis_TEMP2
        with (clustered columnstore index, distribution = hash(Case_Analysis_Skey)) as

SELECT stg.[Work_Flow_Events_Skey]
	  ,stg.[Case_Analysis_Skey]
      ,stg.[WorkFlowStages_Skey]
      ,stg.[WorkFlowEventType_Skey]
      ,stg.[WorkFlowEventDate_Skey]
      ,stg.[WorkFlowEventTime_Skey]
      ,stg.[WorkFlowEstimatedStartDate_Skey]
      ,stg.[WorkFlowEstimatedStartTime_Skey]
      ,stg.[WorkFlowEstimatedEndDate_Skey]
      ,stg.[WorkFlowEstimatedEndTime_Skey]
      ,stg.[WorkFlowOriginalStartDate_Skey]
      ,stg.[WorkFlowOriginalStartTime_Skey]
      ,stg.[WorkFlowEndDate_Skey]
      ,stg.[WorkFlowEndTime_Skey]
      ,stg.[WorkFlowEventEmployee_Skey]
      ,stg.[WorkFlowEventEmployeeHistory_Skey]
      ,stg.[StageOrder]
      ,stg.[EventCount]
      ,stg.[EventOutstandingCount]
      ,stg.[EventCompletedCount]
      ,stg.[EventOverDueCount]
      ,stg.[EventCompletedWithinSLACount]
      ,stg.[EventCompletedOutsideSLACount]
	  ,stg.[EventSkippedCount]
      ,stg.[Sys_LoadDate]
      ,stg.[Sys_ModifiedDate]
      ,stg.[Sys_RunID]
FROM stg.DW_LNK_Work_Flow_Event_Analysis_TEMP1 stg

UNION ALL

SELECT cast(COALESCE((select max(Work_Flow_Events_Skey) from stg.DW_LNK_Work_Flow_Event_Analysis_TEMP1),0) + row_number() over (order by getdate()) as int) as [Work_Flow_Events_Skey]
	  ,stg.[Case_Analysis_Skey]
      ,stg.[WorkFlowStages_Skey]
      ,stg.[WorkFlowEventType_Skey]
      ,stg.[WorkFlowEventDate_Skey]
      ,stg.[WorkFlowEventTime_Skey]
      ,stg.[WorkFlowEstimatedStartDate_Skey]
      ,stg.[WorkFlowEstimatedStartTime_Skey]
      ,stg.[WorkFlowEstimatedEndDate_Skey]
      ,stg.[WorkFlowEstimatedEndTime_Skey]
      ,stg.[WorkFlowOriginalStartDate_Skey]
      ,stg.[WorkFlowOriginalStartTime_Skey]
      ,stg.[WorkFlowEndDate_Skey]
      ,stg.[WorkFlowEndTime_Skey]
      ,stg.[WorkFlowEventEmployee_Skey]
      ,stg.[WorkFlowEventEmployeeHistory_Skey]
      ,stg.[StageOrder]
      ,stg.[EventCount]
      ,stg.[EventOutstandingCount]
      ,stg.[EventCompletedCount]
      ,stg.[EventOverDueCount]
      ,stg.[EventCompletedWithinSLACount]
      ,stg.[EventCompletedOutsideSLACount]
	  ,stg.[EventSkippedCount]
      ,stg.[Sys_LoadDate]
      ,stg.[Sys_ModifiedDate]
      ,stg.[Sys_RunID]
FROM stg.DW_LNK_Work_Flow_Event_Analysis_TEMP stg
        left outer join stg.DW_LNK_Work_Flow_Event_Analysis_TEMP1 stg_t1
		ON stg_t1.Case_Analysis_Skey = stg.Case_Analysis_Skey
		AND stg_t1.[WorkFlowEventType_Skey] = stg.[WorkFlowEventType_Skey]
where   stg_t1.Case_Analysis_Skey is null

-- Create NOT NULL constraint on temp
alter table stg.DW_LNK_Work_Flow_Event_Analysis_TEMP2
ALTER COLUMN Work_Flow_Events_Skey INT NOT NULL

-- Create primary key on temp
alter table stg.DW_LNK_Work_Flow_Event_Analysis_TEMP2
ADD CONSTRAINT PK_DW_LNK_Work_Flow_Event_Analysis PRIMARY KEY NONCLUSTERED (Work_Flow_Events_Skey) NOT ENFORCED

---- Switch table contents replacing target with temp.

alter table DW.LNK_Work_Flow_Event_Analysis switch to OLD.DW_LNK_Work_Flow_Event_Analysis with (truncate_target=on);
alter table stg.DW_LNK_Work_Flow_Event_Analysis_TEMP2 switch to DW.LNK_Work_Flow_Event_Analysis with (truncate_target=on);

drop table stg.DW_LNK_Work_Flow_Event_Analysis_TEMP;
drop table stg.DW_LNK_Work_Flow_Event_Analysis_TEMP1;
drop table stg.DW_LNK_Work_Flow_Event_Analysis_TEMP2;

---- Force replication of table.
--select * from DW.[LNK_Work_Flow_Event_Analysis] order by 1;


----drop table DW.LNK_Work_Flow_Event_Analysis
----drop table OLD.DW_LNK_Work_Flow_Event_Analysis

----CREATE TABLE DW.LNK_Work_Flow_Event_Analysis
----        WITH (clustered columnstore index, distribution = hash(Case_Analysis_Skey)) 
----AS
----select * from stg.DW_LNK_Work_Flow_Event_Analysis_TEMP2 WHERE 1=0

----CREATE TABLE OLD.DW_LNK_Work_Flow_Event_Analysis
----        WITH (clustered columnstore index, distribution = hash(Case_Analysis_Skey)) 
----AS
----select * from stg.DW_LNK_Work_Flow_Event_Analysis_TEMP2 WHERE 1=0