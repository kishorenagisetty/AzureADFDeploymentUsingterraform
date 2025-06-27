CREATE PROC [DW].[F_Case_Analysis_Load] AS


-- -------------------------------------------------------------------
-- Script:         DW.F_Case_Analysis Load
-- Target:         Azure Synapse Data Warehouse
-- -------------------------------------------------------------------

-- Delete temporary tables if present.

if object_id ('stg.DW_F_Case_Analysis_TEMP','U') is not null drop table stg.DW_F_Case_Analysis_TEMP;
if object_id ('stg.DW_F_Case_Analysis_TEMP1','U') is not null drop table stg.DW_F_Case_Analysis_TEMP1;
if object_id ('stg.DW_F_Case_Analysis_TEMP2','U') is not null drop table stg.DW_F_Case_Analysis_TEMP2;

-- -------------------------------------------------------------------
-- First pass creates new versions of existing rows.
-- -------------------------------------------------------------------

-- Get dataset from Data Store
CREATE TABLE stg.DW_F_Case_Analysis_TEMP
        WITH (clustered columnstore index, distribution = hash(CaseBusKey)) 
AS

SELECT
	ds_case.CaseReferenceKey AS [CaseBusKey],
	COALESCE(dw_cand.Candidate_Skey, -1) AS Candidate_Skey,
	COALESCE(dw_case.Case_Skey, -1) AS Case_Skey,
	COALESCE(dw_cs.Source_Skey, -1) AS Source_Skey,
	COALESCE(dw_cst.Case_Status_Skey, -1) AS Case_Status_Skey,
	COALESCE(dw_pr.Programme_Skey, -1) AS Programme_Skey,
	COALESCE(CAST(format(ds_case.Src_CreatedDate,'yyyyMMdd') AS INT), -1) AS CaseCreatedDate_Skey,
	COALESCE(dw_time_crtd.Time_Skey, -1) AS CaseCreatedTime_Skey ,
	COALESCE(CAST(format(ds_case.ReceivedDate,'yyyyMMdd') AS INT), -1) AS CaseReceivedDate_Skey,
	COALESCE(dw_time_rcvd.Time_Skey, -1) AS CaseReceivedTime_Skey ,
	COALESCE(CAST(format(ds_case.PredictedEndDate,'yyyyMMdd') AS INT), -1) AS PredictedEndDate_Skey,
	COALESCE(dw_time_prend.Time_Skey, -1) AS PredictedEndTime_Skey ,
	COALESCE(CAST(format(ds_case.ApprovedDate,'yyyyMMdd') AS INT), -1) AS ApprovedDate_Skey,	
	COALESCE(dw_time_appr.Time_Skey, -1) AS ApprovedTime_Skey ,
	COALESCE(CAST(format(ds_case.CaseClosedDate,'yyyyMMdd') AS INT), -1) AS CaseClosedDate_Skey,
	COALESCE(dw_time_close.Time_Skey, -1) AS CaseClosedTime_Skey ,
	COALESCE(CAST(format(ds_case.PlanActiveDate,'yyyyMMdd') AS INT), -1) AS CasePlanActiveDate_Skey,
	COALESCE(dw_time_plact.Time_Skey, -1) AS CasePlanActiveTime_Skey ,
	COALESCE(dw_emp_cont.Employer_Contact_Skey, -1) AS Employer_Contact_Skey,
	COALESCE(dw_employer.Employer_Skey, -1) AS Employer_Skey,
	COALESCE(dw_attr.Attrition_Reason_Skey, -1) AS Attrition_Reason_Skey,
	COALESCE(dw_emp.Employee_Skey,-1) AS CaseOwnerEmp_Skey,
	COALESCE(dw_emp_h.EmployeeHistory_Skey,-1) AS CaseOwnerEmpHist_Skey,
	1 AS CaseCount,
	COALESCE(dw_curr_stg.Stage_Skey,-1) AS CurrentStage_Skey,
	COALESCE(dw_attr_stg.Stage_Skey,-1) AS AttritionStage_Skey,
	COALESCE(CAST(format(ds_case.AttritionDate,'yyyyMMdd') AS INT), -1) AS AttritionDate_Skey,
	COALESCE(dw_time_attr.Time_Skey, -1) AS AttritionTime_Skey ,
	ds_case.AttritionCount,
	ds_case.AttritionHistoryCount,
	ds_case.AttritionDisengagedCount,
	ds_case.AttritionDisengagedHistoryCount,
	ds_case.AttritionLeftJobCount,
	ds_case.AttritionLeftJobHistoryCount,
	ds_case.AttritionCovidCount,
	ds_case.AttritionCovidHistoryCount,
	CASE 
		WHEN ds_cst.[CaseStatus] = 'Suspended' 
		THEN 1 
		ELSE 0
	END AS SuspendedCount,
	CASE 
		WHEN ds_cst.[CaseStatus] IN ('New Referral','Active Support','Enquiry') 
		THEN 1 
		ELSE 0
	END AS ActiveCount,
	ds_case.Sys_LoadDate,
	ds_case.Sys_RunID

FROM DS.[Cases] ds_case
		LEFT JOIN DS.Customer ds_cust ON ds_case.CustomerID = ds_cust.CustomerID
		LEFT JOIN DS.[Source] ds_cs ON ds_case.SourceID = ds_cs.SourceID
		LEFT JOIN DS.Case_Status ds_cst ON ds_case.CaseStatusID = ds_cst.CaseStatusID
		LEFT JOIN DS.[Programme] ds_pr ON ds_case.ProgrammeID = ds_pr.ProgrammeID
		LEFT JOIN DS.[Attrition_Reason] ds_attr ON ds_case.AttritionReasonID = ds_attr.AttritionReasonID
		LEFT JOIN DS.Employee ds_emp ON ds_case.[CaseOwnerEmpID] = ds_emp.[EmployeeID]
		LEFT JOIN DS.Employee_History ds_emp_h ON ds_case.[CaseOwnerEmpID] = ds_emp_h.[EmployeeID]
		AND GETDATE() BETWEEN ds_emp_h.[Start] AND ds_emp_h.[End]
		LEFT JOIN DS.Work_Flow_Case_Stages ds_wfs ON ds_case.caseid = ds_wfs.caseid
		AND GETDATE() BETWEEN ds_wfs.[WorkFlowStageStartDate] AND ds_wfs.[WorkFlowStageEndDate]
		LEFT JOIN DS.Work_Flow_Case_Stages ds_attr_st ON ds_case.caseid = ds_attr_st.caseid
		AND ds_case.AttritionDate BETWEEN ds_attr_st.[WorkFlowStageStartDate] AND ds_attr_st.[WorkFlowStageEndDate]

		LEFT JOIN DW.D_Case dw_case ON ds_case.CaseID = dw_case.CaseBusKey
		LEFT JOIN DW.D_Candidate dw_cand ON ds_cust.CustomerID = dw_cand.CandidateBusKey
		LEFT JOIN DW.D_Source dw_cs ON ds_cs.SourceID = dw_cs.SourceBusKey
		LEFT JOIN DW.D_Case_Status dw_cst ON ds_cst.CaseStatusID = dw_cst.CaseStatusBusKey
		LEFT JOIN DW.D_Programme dw_pr ON ds_pr.ProgrammeID = dw_pr.ProgrammeBusKey
		LEFT JOIN DW.D_Attrition_Reason dw_attr ON ds_attr.AttritionReasonID = dw_attr.AttritionReasonBusKey
		LEFT JOIN DW.D_Time dw_time_crtd ON convert(time,ds_case.Src_CreatedDate) = dw_time_crtd.[Time]
		LEFT JOIN DW.D_Time dw_time_rcvd ON convert(time,ds_case.ReceivedDate) = dw_time_rcvd.[Time]
		LEFT JOIN DW.D_Time dw_time_prend ON convert(time,ds_case.PredictedEndDate) = dw_time_prend.[Time]
		LEFT JOIN DW.D_Time dw_time_appr ON convert(time,ds_case.ApprovedDate) = dw_time_appr.[Time]
		LEFT JOIN DW.D_Time dw_time_close ON convert(time,ds_case.CaseClosedDate) = dw_time_close.[Time]
		LEFT JOIN DW.D_Time dw_time_plact ON convert(time,ds_case.PlanActiveDate) = dw_time_plact.[Time]
		LEFT JOIN DW.D_Time dw_time_attr ON convert(time,ds_case.attritiondate) = dw_time_attr.[Time]
		LEFT JOIN DW.D_Employee dw_emp ON ds_emp.EmployeeID =  dw_emp.EmployeeBusKey
		LEFT JOIN DW.D_Employee_History dw_emp_h ON ds_emp_h.EmployeeHistoryID =  dw_emp_h.EmployeeHistoryBusKey
		LEFT JOIN DW.D_Stage dw_curr_stg ON ds_wfs.WorkFlowStageID = dw_curr_stg.StageBusKey
		LEFT JOIN DW.D_Stage dw_attr_stg ON ds_attr_st.WorkFlowStageID = dw_attr_stg.StageBusKey
		LEFT JOIN DW.D_Employer dw_employer ON ds_case.OrganisationRoleID = dw_employer.EmployerBusKey
		LEFT JOIN DW.D_Employer_Contact dw_emp_cont ON ds_case.ContactRoleID = dw_emp_cont.EmployerContactBusKey

WHERE
	ds_case.sys_IsCurrent = 1
	and ds_case.ProviderID <> 208
	AND ds_case.Active = 1

-- Update Existing Rows
CREATE TABLE stg.DW_F_Case_Analysis_TEMP1
        WITH (clustered columnstore index, distribution = hash(CaseBusKey)) as

SELECT
	dw.[Case_Analysis_Skey],
	stg.[CaseBusKey],
	stg.Candidate_Skey,
	stg.Case_Skey,
	stg.Source_Skey,
	stg.Case_Status_Skey,
	stg.Programme_Skey,
	stg.CaseCreatedDate_Skey,
	stg.CaseCreatedTime_Skey ,
	stg.CaseReceivedDate_Skey,
	stg.CaseReceivedTime_Skey ,
	stg.PredictedEndDate_Skey,
	stg.PredictedEndTime_Skey ,
	stg.ApprovedDate_Skey,	
	stg.ApprovedTime_Skey ,
	stg.CaseClosedDate_Skey,
	stg.CaseClosedTime_Skey ,
	stg.CasePlanActiveDate_Skey,
	stg.CasePlanActiveTime_Skey ,
	stg.Employer_Contact_Skey,
	stg.Employer_Skey,
	stg.Attrition_Reason_Skey,
	stg.CaseOwnerEmp_Skey,
	stg.CaseOwnerEmpHist_Skey,
	stg.CaseCount,
	stg.CurrentStage_Skey,
	stg.AttritionStage_Skey,
	stg.AttritionDate_Skey,
	stg.AttritionTime_Skey ,
	stg.AttritionCount,
	stg.AttritionHistoryCount,
	stg.AttritionDisengagedCount,
	stg.AttritionDisengagedHistoryCount,
	stg.AttritionLeftJobCount,
	stg.AttritionLeftJobHistoryCount,
	stg.AttritionCovidCount,
	stg.AttritionCovidHistoryCount,
	stg.SuspendedCount,
	stg.ActiveCount,
	stg.Sys_LoadDate,
	stg.Sys_RunID
FROM stg.DW_F_Case_Analysis_TEMP stg
	INNER JOIN DW.F_Case_Analysis DW
		ON DW.CaseBusKey = stg.CaseBusKey

-- -------------------------------------------------------------------
-- Second pass appends new rows to table
-- -------------------------------------------------------------------

-- Copy current table .. note distribution to REPLICATE

create  table stg.DW_F_Case_Analysis_TEMP2
        with (clustered columnstore index, distribution = hash(case_skey)) as

SELECT
	stg.[Case_Analysis_Skey],
	stg.[CaseBusKey],
	stg.Candidate_Skey,
	stg.Case_Skey,
	stg.Source_Skey,
	stg.Case_Status_Skey,
	stg.Programme_Skey,
	stg.CaseCreatedDate_Skey,
	stg.CaseCreatedTime_Skey ,
	stg.CaseReceivedDate_Skey,
	stg.CaseReceivedTime_Skey ,
	stg.PredictedEndDate_Skey,
	stg.PredictedEndTime_Skey ,
	stg.ApprovedDate_Skey,	
	stg.ApprovedTime_Skey ,
	stg.CaseClosedDate_Skey,
	stg.CaseClosedTime_Skey ,
	stg.CasePlanActiveDate_Skey,
	stg.CasePlanActiveTime_Skey ,
	stg.Employer_Contact_Skey,
	stg.Employer_Skey,
	stg.Attrition_Reason_Skey,
	stg.CaseOwnerEmp_Skey,
	stg.CaseOwnerEmpHist_Skey,
	stg.CaseCount,
	stg.CurrentStage_Skey,
	stg.AttritionStage_Skey,
	stg.AttritionDate_Skey,
	stg.AttritionTime_Skey ,
	stg.AttritionCount,
	stg.AttritionHistoryCount,
	stg.AttritionDisengagedCount,
	stg.AttritionDisengagedHistoryCount,
	stg.AttritionLeftJobCount,
	stg.AttritionLeftJobHistoryCount,
	stg.AttritionCovidCount,
	stg.AttritionCovidHistoryCount,
	stg.SuspendedCount,
	stg.ActiveCount,
	stg.Sys_LoadDate,
	stg.Sys_RunID
FROM stg.DW_F_Case_Analysis_TEMP1 stg

UNION ALL

-- Add new rows.
SELECT
	cast(COALESCE((select max(Case_Analysis_Skey) from stg.DW_F_Case_Analysis_TEMP1),0) + row_number() over (order by getdate()) as int) as [Case_Analysis_Skey],
	stg.[CaseBusKey],
	stg.Candidate_Skey,
	stg.Case_Skey,
	stg.Source_Skey,
	stg.Case_Status_Skey,
	stg.Programme_Skey,
	stg.CaseCreatedDate_Skey,
	stg.CaseCreatedTime_Skey ,
	stg.CaseReceivedDate_Skey,
	stg.CaseReceivedTime_Skey ,
	stg.PredictedEndDate_Skey,
	stg.PredictedEndTime_Skey ,
	stg.ApprovedDate_Skey,	
	stg.ApprovedTime_Skey ,
	stg.CaseClosedDate_Skey,
	stg.CaseClosedTime_Skey ,
	stg.CasePlanActiveDate_Skey,
	stg.CasePlanActiveTime_Skey ,
	stg.Employer_Contact_Skey,
	stg.Employer_Skey,
	stg.Attrition_Reason_Skey,
	stg.CaseOwnerEmp_Skey,
	stg.CaseOwnerEmpHist_Skey,
	stg.CaseCount,
	stg.CurrentStage_Skey,
	stg.AttritionStage_Skey,
	stg.AttritionDate_Skey,
	stg.AttritionTime_Skey ,
	stg.AttritionCount,
	stg.AttritionHistoryCount,
	stg.AttritionDisengagedCount,
	stg.AttritionDisengagedHistoryCount,
	stg.AttritionLeftJobCount,
	stg.AttritionLeftJobHistoryCount,
	stg.AttritionCovidCount,
	stg.AttritionCovidHistoryCount,
	stg.SuspendedCount,
	stg.ActiveCount,
	stg.Sys_LoadDate,
	stg.Sys_RunID
from    stg.DW_F_Case_Analysis_TEMP stg
        left outer join stg.DW_F_Case_Analysis_TEMP1 stg_t1
        on stg_t1.CaseBusKey = stg.CaseBusKey
where   stg_t1.CaseBusKey is null

-- Create NOT NULL constraint on temp
alter table stg.DW_F_Case_Analysis_TEMP2
ALTER COLUMN Case_Analysis_Skey INT NOT NULL

-- Create primary key on temp
alter table stg.DW_F_Case_Analysis_TEMP2
ADD CONSTRAINT PK_DW_F_Case_Analysis PRIMARY KEY NONCLUSTERED (Case_Analysis_Skey) NOT ENFORCED

---- Switch table contents replacing target with temp.

alter table DW.F_Case_Analysis switch to OLD.DW_F_Case_Analysis with (truncate_target=on);
alter table stg.DW_F_Case_Analysis_TEMP2 switch to DW.F_Case_Analysis with (truncate_target=on);

drop table stg.DW_F_Case_Analysis_TEMP;
drop table stg.DW_F_Case_Analysis_TEMP1;
drop table stg.DW_F_Case_Analysis_TEMP2;

---- Force replication of table.
--select * from DW.[F_Case_Analysis] order by 1;


--drop table DW.F_Case_Analysis
--drop table OLD.DW_F_Case_Analysis

--CREATE TABLE DW.F_Case_Analysis
--        WITH (clustered columnstore index, distribution = hash(Case_Skey)) 
--AS
--select 1 AS Case_Analysis_Skey, a.* from stg.DW_F_Case_Analysis_TEMP a where 1=0

--CREATE TABLE OLD.DW_F_Case_Analysis
--        WITH (clustered columnstore index, distribution = hash(Case_Skey)) 
--AS
--select 1 AS Case_Analysis_Skey, a.* from stg.DW_F_Case_Analysis_TEMP a where 1=0