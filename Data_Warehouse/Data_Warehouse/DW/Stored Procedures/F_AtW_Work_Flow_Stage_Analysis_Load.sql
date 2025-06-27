CREATE PROC [DW].[F_AtW_Work_Flow_Stage_Analysis_Load] AS

-- -------------------------------------------------------------------
-- Script:         DW.F_AtW_Work_Flow_Stage_Analysis Load
-- Target:         Azure Synapse Data Warehouse
-- -------------------------------------------------------------------

-- Delete temporary tables if present.

if object_id ('stg.DW_F_AtW_Work_Flow_Stage_Analysis_TEMP','U') is not null drop table stg.DW_F_AtW_Work_Flow_Stage_Analysis_TEMP;

-------- -------------------------------------------------------------------
-------- Create new table
-------- -------------------------------------------------------------------

------ Get dataset from Landing Zone
CREATE TABLE stg.DW_F_AtW_Work_Flow_Stage_Analysis_TEMP
        WITH (clustered columnstore index, distribution = hash(Case_Skey)) 
AS

WITH
Monthly_Activity as 
(
select 
	    Case_Analysis_Skey
	  , WorkFlowStages_Skey
	  , MAX(MA_Completed)						AS MA_Completed
	  , MAX(MA_Outstanding)						AS MA_Outstanding
	  ,	MAX(MA_Month6or9MeetingScheduled)		AS MA_Month6or9MeetingScheduled
	  ,	MIN(DaysToCompleteMonthlyActivity)		AS DaysToCompleteMonthlyActivity
	  ,	MIN(MonthlyActivityCompleteWithinSLA)	AS MonthlyActivityCompleteWithinSLA
	  ,	MIN(CASE WHEN MonthlyActivityCompleteWithinSLA = 1 THEN 0 ELSE MonthlyActivityCompleteOutsideSLA END)	AS MonthlyActivityCompleteOutsideSLA
FROM 
(
		SELECT --stg.stage, et.workfloweventtype,et.monthlyactivitytype,ev.[WorkFlowEventDate_Skey],
		  ev.[Case_Analysis_Skey]
		, ev.[WorkFlowStages_Skey],
		  CASE 
			when et.MonthlyActivityType = 'Complete' 
			then 1 
		  END AS MA_Completed  
		,
		  case 
			when et.MonthlyActivityType = 'Complete' 
			then datediff (Day,Sla_Start.[Date],d.[Date]) 
		  end AS DaysToCompleteMonthlyActivity
	  , case 
			when et.MonthlyActivityType = 'Complete' 
			and  WorkFlowEventDate_Skey <=  [WorkFlowEstimatedEndDate_Skey] 
			then 1 
		end AS MonthlyActivityCompleteWithinSLA
	  , case 
			when et.MonthlyActivityType = 'Complete' 
			and  WorkFlowEventDate_Skey > [WorkFlowEstimatedEndDate_Skey]  
			then 1 
		end AS MonthlyActivityCompleteOutsideSLA
	 , case 
		 when et.MonthlyActivityType = 'Outstanding' then 1 
	   end MA_Outstanding
	 , case 
		 when et.MonthlyActivityType IN ('Month6MeetingSched','Month9MeetingSched') then 1 
	   end as MA_Month6or9MeetingScheduled
	FROM
		[DW].[LNK_Work_Flow_Event_Analysis] ev
			inner join [DW].[D_Work_Flow_Event_Type] et
				on (et.[Work_Flow_Event_Type_Skey] = ev.[WorkFlowEventType_Skey])
			inner join [DW].[D_Date] d 
				on (d.[Date_Skey] = ev.WorkFlowEventDate_Skey)
			inner join [DW].[D_Date] Sla_Start 
				on (Sla_Start.[Date_Skey] = ev.[WorkFlowEstimatedStartDate_Skey])

				inner join  [DW].[D_Stage] stg 
			on (stg.[Stage_Skey] = ev.[WorkFlowStages_Skey])
	WHERE 
		ev.[WorkFlowEventDate_Skey] <> -1
		) subq
group by  
		[Case_Analysis_Skey], 
		[WorkFlowStages_Skey] )

SELECT 
	  lnk.Work_Flow_Stages_Skey
	, lnk.Stage_Skey
	, lnk.WorkFlowStartDate_Skey
	, lnk.WorkFlowStartTime_Skey
	, lnk.WorkFlowEndDate_Skey
	, lnk.WorkFlowEndTime_Skey
	, [Candidate_Skey]
    , [Case_Skey]
    , [Source_Skey]
    , [Case_Status_Skey]
    , [Programme_Skey]
    , [CaseCreatedDate_Skey]
    , [CaseCreatedTime_Skey]
    , [CaseReceivedDate_Skey]
    , [CaseReceivedTime_Skey]
    , [PredictedEndDate_Skey]
    , [PredictedEndTime_Skey]
    , [ApprovedDate_Skey]
    , [ApprovedTime_Skey]
    , [CaseClosedDate_Skey]
    , [CaseClosedTime_Skey]
    , [CasePlanActiveDate_Skey]
    , [CasePlanActiveTime_Skey]
    , [Employer_Contact_Skey]
    , [Employer_Skey]
    , [Attrition_Reason_Skey]
    , [CaseOwnerEmp_Skey]
    , [CaseOwnerEmpHist_Skey]
    , [CurrentStage_Skey]
    , [AttritionStage_Skey]
    , [AttritionDate_Skey]
    , [AttritionTime_Skey]
	, COALESCE(MA_Outstanding,0)						AS MonthlyActivityOutstanding
	, COALESCE(ma.MA_Completed, 0)						AS MonthlyActivityComplete
	, COALESCE(MA_Month6or9MeetingScheduled,0)			AS MA_Month6or9MeetingScheduled
	, COALESCE(DaysToCompleteMonthlyActivity,0)			AS DaysToCompleteMonthlyActivity
	, COALESCE(MonthlyActivityCompleteWithinSLA,0)		AS MonthlyActivityCompleteWithinSLA
	, COALESCE(MonthlyActivityCompleteOutsideSLA,0)		AS MonthlyActivityCompleteOutsideSLA

FROM 
	  [DW].[LNK_Work_Flow_Stages] lnk
		inner join  [DW].[D_Stage] stg 
			on (stg.[Stage_Skey] = lnk.[Stage_Skey])
		INNER JOIN  [DW].[F_Case_Analysis] dw_f_ca 
			ON dw_f_ca.[Case_Analysis_Skey] = lnk.[Case_Analysis_Skey]
		left outer join Monthly_Activity ma 
			on (ma.Case_Analysis_Skey = lnk.Case_Analysis_Skey and ma.WorkFlowStages_Skey = lnk.Stage_Skey)


 -- Create NOT NULL constraint on temp
--alter table stg.DW_F_AtW_Work_Flow_Stage_Analysis_TEMP
--ALTER COLUMN Case_Analysis_Skey INT NOT NULL

-- Create primary key on temp
--alter table stg.DW_F_AtW_Work_Flow_Stage_Analysis_TEMP
--ADD CONSTRAINT PK_DW_F_AtW_Work_Flow_Stage_Analysis PRIMARY KEY NONCLUSTERED (Case_Analysis_Skey) NOT ENFORCED

-- Switch table contents replacing target with temp.

alter table DW.F_AtW_Work_Flow_Stage_Analysis switch to OLD.DW_F_AtW_Work_Flow_Stage_Analysis with (truncate_target=on);
alter table stg.DW_F_AtW_Work_Flow_Stage_Analysis_TEMP switch to DW.F_AtW_Work_Flow_Stage_Analysis with (truncate_target=on);

drop table stg.DW_F_AtW_Work_Flow_Stage_Analysis_TEMP;

---- Force replication of table.
--select * from DW.[F_AtW_Work_Flow_Stage_Analysis] order by 1;


--drop table DW.F_AtW_Work_Flow_Stage_Analysis
--drop table OLD.DW_F_AtW_Work_Flow_Stage_Analysis

--CREATE TABLE DW.F_AtW_Work_Flow_Stage_Analysis
--        WITH (clustered columnstore index, distribution = hash(Case_Skey)) 
--AS
--select * from stg.DW_F_AtW_Work_Flow_Stage_Analysis_TEMP WHERE 1=0

--CREATE TABLE OLD.DW_F_AtW_Work_Flow_Stage_Analysis
--        WITH (clustered columnstore index, distribution = hash(Case_Skey)) 
--AS
--select * from stg.DW_F_AtW_Work_Flow_Stage_Analysis_TEMP WHERE 1=0
