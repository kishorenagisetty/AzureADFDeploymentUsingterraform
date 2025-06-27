CREATE PROC [DW].[F_Task_Analysis_Load] AS


-- -------------------------------------------------------------------
-- Script:         DW.F_Task_Analysis Load
-- Target:         Azure Synapse Data Warehouse
-- -------------------------------------------------------------------

-- Delete temporary tables if present.

if object_id ('stg.DW_F_Task_Analysis_TEMP','U')  IS NOT NULL drop table stg.DW_F_Task_Analysis_TEMP;
if object_id ('stg.DW_F_Task_Analysis_TEMP1','U') IS NOT NULL drop table stg.DW_F_Task_Analysis_TEMP1;
if object_id ('stg.DW_F_Task_Analysis_TEMP2','U') IS NOT NULL drop table stg.DW_F_Task_Analysis_TEMP2;

---- -------------------------------------------------------------------
---- First pass creates new versions of existing rows.
---- -------------------------------------------------------------------

---- Get dataset from Data Store
CREATE TABLE stg.DW_F_Task_Analysis_TEMP
        WITH (clustered columnstore index, distribution = hash(Case_Skey)) 
AS

SELECT
      COALESCE(ds_t.TaskID, -1)												AS [TaskAnalysisBusKey]
	, COALESCE(dw_tt.Task_Type_Skey, -1)									AS [Task_Type_Skey]
	, COALESCE(dw_ts.Task_Status_Skey, -1)									AS [Task_Status_Skey]
	, COALESCE(CAST(format(ds_t.TaskCreatedDate,'yyyyMMdd') AS INT), -1)	AS [TaskCreatedDate_Skey]
	, COALESCE(dw_time.Time_Skey, -1)										AS [TaskCreatedTime_Skey]
	, COALESCE(dw_emp_ass.Employee_Skey, -1)								AS [TaskAssigneeEmployee_Skey]
	, COALESCE(dw_emp_crt.Employee_Skey, -1)								AS [TaskCreatedByEmployee_Skey]
	, COALESCE(f_ca.[Candidate_Skey]	, -1)								AS [Candidate_Skey]
    , COALESCE(f_ca.[Case_Skey]	, -1)										AS [Case_Skey]
    , COALESCE(f_ca.[Source_Skey], -1)										AS [Source_Skey]
    , COALESCE(f_ca.[Case_Status_Skey], -1)									AS [Case_Status_Skey]
    , COALESCE(f_ca.[Programme_Skey]	, -1)								AS [Programme_Skey]
    , COALESCE(f_ca.[CaseCreatedDate_Skey], -1)								AS [CaseCreatedDate_Skey]
    , COALESCE(f_ca.[CaseCreatedTime_Skey], -1)								AS [CaseCreatedTime_Skey]
    , COALESCE(f_ca.[CaseReceivedDate_Skey], -1)							AS [CaseReceivedDate_Skey]
    , COALESCE(f_ca.[CaseReceivedTime_Skey], -1)							AS [CaseReceivedTime_Skey]
    , COALESCE(f_ca.[PredictedEndDate_Skey], -1)							AS [PredictedEndDate_Skey]
    , COALESCE(f_ca.[PredictedEndTime_Skey]	, -1)							AS [PredictedEndTime_Skey]
    , COALESCE(f_ca.[ApprovedDate_Skey]	, -1)								AS [ApprovedDate_Skey]
    , COALESCE(f_ca.[ApprovedTime_Skey]	, -1)								AS [ApprovedTime_Skey]
    , COALESCE(f_ca.[CaseClosedDate_Skey], -1)								AS [CaseClosedDate_Skey]
    , COALESCE(f_ca.[CaseClosedTime_Skey], -1)								AS [CaseClosedTime_Skey]
    , COALESCE(f_ca.[CasePlanActiveDate_Skey], -1)							AS [CasePlanActiveDate_Skey]
    , COALESCE(f_ca.[CasePlanActiveTime_Skey], -1)							AS [CasePlanActiveTime_Skey]
    , COALESCE(f_ca.[Employer_Contact_Skey]	, -1)							AS [Employer_Contact_Skey]
    , COALESCE(f_ca.[Employer_Skey]	, -1)									AS [Employer_Skey]
    , COALESCE(f_ca.[Attrition_Reason_Skey], -1)							AS [Attrition_Reason_Skey]
    , COALESCE(f_ca.[CaseOwnerEmp_Skey], -1)								AS [CaseOwnerEmp_Skey]
    , COALESCE(f_ca.[CaseOwnerEmpHist_Skey], -1)							AS [CaseOwnerEmpHist_Skey]
    , COALESCE(f_ca.[CaseCount], -1)										AS [CaseCount]
    , COALESCE(f_ca.[CurrentStage_Skey], -1)								AS [CurrentStage_Skey]
    , COALESCE(f_ca.[AttritionStage_Skey], -1)								AS [AttritionStage_Skey]
    , COALESCE(f_ca.[AttritionDate_Skey]	, -1)							AS [AttritionDate_Skey]
    , COALESCE(f_ca.[AttritionTime_Skey], -1)								AS [AttritionTime_Skey]
	, 1 as TaskCount
	, CASE WHEN ROW_NUMBER() OVER (PARTITION BY f_ca.[Case_Skey], dw_tt.Task_Type_Skey ORDER BY ds_t.TaskCreatedDate) = 1 THEN 1 ELSE 0 END AS [FirstOccurrence] 
	, CASE WHEN ROW_NUMBER() OVER (PARTITION BY f_ca.[Case_Skey], dw_tt.Task_Type_Skey ORDER BY ds_t.TaskCreatedDate) = COUNT(*) OVER (PARTITION BY f_ca.[Case_Skey], dw_tt.Task_Type_Skey) THEN 1 ELSE 0 END AS [LastOccurrence] 
	, ds_t.Sys_LoadDate
	, ds_t.Sys_ModifiedDate
	, ds_t.Sys_RunID
FROM	
	DS.Task ds_t
		LEFT JOIN DW.D_Task_Type dw_tt
			ON ds_t.TaskTypeID = dw_tt.TaskTypeBusKey
		LEFT JOIN DW.D_Task_Status dw_ts
			ON ds_t.TaskStatusID = dw_ts.TaskStatusBusKey
		LEFT JOIN DW.D_Employee dw_emp_ass
			ON ds_t.TaskAssigneeEmployeeID = dw_emp_ass.EmployeeBusKey
		LEFT JOIN DW.D_Employee dw_emp_crt
			ON ds_t.TaskCreatedByEmployeeID = dw_emp_crt.EmployeeBusKey
		LEFT JOIN DW.D_Case dw_c
			ON ds_t.CaseID = dw_c.CaseBusKey
		LEFT JOIN DW.F_Case_Analysis f_ca
			ON dw_c.Case_Skey = f_ca.Case_Skey
		LEFT JOIN DW.D_Time dw_time
			ON convert(time,ds_t.TaskCreatedDate) = dw_time.[Time]	

-- Update Existing Rows
CREATE TABLE stg.DW_F_Task_Analysis_TEMP1
        WITH (clustered columnstore index, distribution = hash(Case_Skey)) as

SELECT  DW.[Task_Analysis_Skey]
	,	stg.[TaskAnalysisBusKey]
	,	stg.[Task_Type_Skey]
	,	stg.[Task_Status_Skey]
	,	stg.[TaskCreatedDate_Skey]
	,	stg.[TaskCreatedTime_Skey]
	,	stg.[TaskAssigneeEmployee_Skey]
	,	stg.[TaskCreatedByEmployee_Skey]
	,	stg.[Candidate_Skey]
	,	stg.[Case_Skey]
	,	stg.[Source_Skey]
	,	stg.[Case_Status_Skey]
	,	stg.[Programme_Skey]
	,	stg.[CaseCreatedDate_Skey]
	,	stg.[CaseCreatedTime_Skey]
	,	stg.[CaseReceivedDate_Skey]
	,	stg.[CaseReceivedTime_Skey]
	,	stg.[PredictedEndDate_Skey]
	,	stg.[PredictedEndTime_Skey]
	,	stg.[ApprovedDate_Skey]
	,	stg.[ApprovedTime_Skey]
	,	stg.[CaseClosedDate_Skey]
	,	stg.[CaseClosedTime_Skey]
	,	stg.[CasePlanActiveDate_Skey]
	,	stg.[CasePlanActiveTime_Skey]
	,	stg.[Employer_Contact_Skey]
	,	stg.[Employer_Skey]
	,	stg.[Attrition_Reason_Skey]
	,	stg.[CaseOwnerEmp_Skey]
	,	stg.[CaseOwnerEmpHist_Skey]
	,	stg.[CaseCount]
	,	stg.[CurrentStage_Skey]
	,	stg.[AttritionStage_Skey]
	,	stg.[AttritionDate_Skey]
	,	stg.[AttritionTime_Skey]
	,   stg.TaskCount
	,   stg.FirstOccurrence
	,   stg.LastOccurrence
	,   stg.Sys_LoadDate
	,   stg.Sys_ModifiedDate
	,   stg.Sys_RunID
FROM stg.DW_F_Task_Analysis_TEMP stg
	INNER JOIN DW.F_Task_Analysis DW
		ON DW.TaskAnalysisBusKey = stg.TaskAnalysisBusKey

---- -------------------------------------------------------------------
---- Second pass appends new rows to table
---- -------------------------------------------------------------------

---- Copy current table .. note distribution to REPLICATE

create  table stg.DW_F_Task_Analysis_TEMP2
        with (clustered columnstore index, distribution = hash(Case_Skey)) as

SELECT  stg.[Task_Analysis_Skey]
	,	stg.[TaskAnalysisBusKey]
	,	stg.[Task_Type_Skey]
	,	stg.[Task_Status_Skey]
	,	stg.[TaskCreatedDate_Skey]
	,	stg.[TaskCreatedTime_Skey]
	,	stg.[TaskAssigneeEmployee_Skey]
	,	stg.[TaskCreatedByEmployee_Skey]
	,	stg.[Candidate_Skey]
	,	stg.[Case_Skey]
	,	stg.[Source_Skey]
	,	stg.[Case_Status_Skey]
	,	stg.[Programme_Skey]
	,	stg.[CaseCreatedDate_Skey]
	,	stg.[CaseCreatedTime_Skey]
	,	stg.[CaseReceivedDate_Skey]
	,	stg.[CaseReceivedTime_Skey]
	,	stg.[PredictedEndDate_Skey]
	,	stg.[PredictedEndTime_Skey]
	,	stg.[ApprovedDate_Skey]
	,	stg.[ApprovedTime_Skey]
	,	stg.[CaseClosedDate_Skey]
	,	stg.[CaseClosedTime_Skey]
	,	stg.[CasePlanActiveDate_Skey]
	,	stg.[CasePlanActiveTime_Skey]
	,	stg.[Employer_Contact_Skey]
	,	stg.[Employer_Skey]
	,	stg.[Attrition_Reason_Skey]
	,	stg.[CaseOwnerEmp_Skey]
	,	stg.[CaseOwnerEmpHist_Skey]
	,	stg.[CaseCount]
	,	stg.[CurrentStage_Skey]
	,	stg.[AttritionStage_Skey]
	,	stg.[AttritionDate_Skey]
	,	stg.[AttritionTime_Skey]
	,   stg.TaskCount
	,   stg.FirstOccurrence
	,   stg.LastOccurrence
	,   stg.Sys_LoadDate
	,   stg.Sys_ModifiedDate
	,   stg.Sys_RunID
FROM stg.DW_F_Task_Analysis_TEMP1 stg

UNION ALL

SELECT cast(COALESCE((select max(Task_Analysis_Skey) from stg.DW_F_Task_Analysis_TEMP1),0) + row_number() over (order by getdate()) as int) as [Task_Analysis_Skey]
	,   stg.[TaskAnalysisBusKey]
	,	stg.[Task_Type_Skey]
	,	stg.[Task_Status_Skey]
	,	stg.[TaskCreatedDate_Skey]
	,	stg.[TaskCreatedTime_Skey]
	,	stg.[TaskAssigneeEmployee_Skey]
	,	stg.[TaskCreatedByEmployee_Skey]
	,	stg.[Candidate_Skey]
	,	stg.[Case_Skey]
	,	stg.[Source_Skey]
	,	stg.[Case_Status_Skey]
	,	stg.[Programme_Skey]
	,	stg.[CaseCreatedDate_Skey]
	,	stg.[CaseCreatedTime_Skey]
	,	stg.[CaseReceivedDate_Skey]
	,	stg.[CaseReceivedTime_Skey]
	,	stg.[PredictedEndDate_Skey]
	,	stg.[PredictedEndTime_Skey]
	,	stg.[ApprovedDate_Skey]
	,	stg.[ApprovedTime_Skey]
	,	stg.[CaseClosedDate_Skey]
	,	stg.[CaseClosedTime_Skey]
	,	stg.[CasePlanActiveDate_Skey]
	,	stg.[CasePlanActiveTime_Skey]
	,	stg.[Employer_Contact_Skey]
	,	stg.[Employer_Skey]
	,	stg.[Attrition_Reason_Skey]
	,	stg.[CaseOwnerEmp_Skey]
	,	stg.[CaseOwnerEmpHist_Skey]
	,	stg.[CaseCount]
	,	stg.[CurrentStage_Skey]
	,	stg.[AttritionStage_Skey]
	,	stg.[AttritionDate_Skey]
	,	stg.[AttritionTime_Skey]
	,   stg.TaskCount
	,   stg.FirstOccurrence
	,   stg.LastOccurrence
	,   stg.Sys_LoadDate
	,   stg.Sys_ModifiedDate
	,   stg.Sys_RunID
FROM stg.DW_F_Task_Analysis_TEMP stg
        left outer join stg.DW_F_Task_Analysis_TEMP1 stg_t1
		ON stg_t1.TaskAnalysisBusKey = stg.TaskAnalysisBusKey
where   stg_t1.TaskAnalysisBusKey is null

-- Create NOT NULL constraint on temp
alter table stg.DW_F_Task_Analysis_TEMP2
ALTER COLUMN Task_Analysis_Skey INT NOT NULL

-- Create primary key on temp
alter table stg.DW_F_Task_Analysis_TEMP2
ADD CONSTRAINT PK_DW_F_Task_Analysis PRIMARY KEY NONCLUSTERED (Task_Analysis_Skey) NOT ENFORCED

---- Switch table contents replacing target with temp.

alter table DW.F_Task_Analysis switch to OLD.DW_F_Task_Analysis with (truncate_target=on);
alter table stg.DW_F_Task_Analysis_TEMP2 switch to DW.F_Task_Analysis with (truncate_target=on);

drop table stg.DW_F_Task_Analysis_TEMP;
drop table stg.DW_F_Task_Analysis_TEMP1;
drop table stg.DW_F_Task_Analysis_TEMP2;

---- Force replication of table.
--select * from DW.[F_Task_Analysis] order by 1;


----drop table DW.F_Task_Analysis
----drop table OLD.DW_F_Task_Analysis

----CREATE TABLE DW.F_Task_Analysis
----        WITH (clustered columnstore index, distribution = hash(Case_Skey)) 
----AS
----select 1 AS Task_Analysis_Skey ,a.* from stg.DW_F_Task_Analysis_TEMP a WHERE 1=0

----CREATE TABLE OLD.DW_F_Task_Analysis
----        WITH (clustered columnstore index, distribution = hash(Case_Skey)) 
----AS
----select * from stg.DW_F_Task_Analysis_TEMP2 WHERE 1=0