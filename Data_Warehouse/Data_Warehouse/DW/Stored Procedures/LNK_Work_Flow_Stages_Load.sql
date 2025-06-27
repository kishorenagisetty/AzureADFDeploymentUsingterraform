CREATE PROC [DW].[LNK_Work_Flow_Stages_Load] AS


-- -------------------------------------------------------------------
-- Script:         DW.LNK_Work_Flow_Stages Load
-- Target:         Azure Synapse Data Warehouse
-- -------------------------------------------------------------------

-- Delete temporary tables if present.

if object_id ('stg.DW_LNK_Work_Flow_Stages_TEMP','U') is not null drop table stg.DW_LNK_Work_Flow_Stages_TEMP;
if object_id ('stg.DW_LNK_Work_Flow_Stages_TEMP1','U') is not null drop table stg.DW_LNK_Work_Flow_Stages_TEMP1;
if object_id ('stg.DW_LNK_Work_Flow_Stages_TEMP2','U') is not null drop table stg.DW_LNK_Work_Flow_Stages_TEMP2;

-- -------------------------------------------------------------------
-- First pass creates new versions of existing rows.
-- -------------------------------------------------------------------

-- Get dataset from Data Store
CREATE TABLE stg.DW_LNK_Work_Flow_Stages_TEMP
        WITH (clustered columnstore index, distribution = hash(Case_Analysis_Skey)) 
AS

SELECT
	  COALESCE(dw_f_ca.Case_Analysis_Skey,-1) AS Case_Analysis_Skey
	, COALESCE(dw_stg.Stage_Skey,-1)  AS Stage_Skey
	, COALESCE(CAST(format(ds_wfs.WorkFlowStageStartDate,'yyyyMMdd') AS INT), -1) AS WorkFlowStartDate_Skey
	, COALESCE(dw_time_wfst.Time_Skey, -1) AS WorkFlowStartTime_Skey
	, COALESCE(CAST(format(ds_wfs.WorkFlowStageEndDate,'yyyyMMdd') AS INT), -1) AS WorkFlowEndDate_Skey
	, COALESCE(dw_time_wfet.Time_Skey, -1) AS WorkFlowEndTime_Skey
	, dw_stg.StageOrder 
	, ds_wfs.Sys_LoadDate
	, ds_wfs.Sys_ModifiedDate
	, ds_wfs.Sys_RunID
FROM
	DS.Work_Flow_Case_Stages ds_wfs
		INNER JOIN DS.[Cases] ds_cs ON ds_wfs.CaseID = ds_cs.CaseID
		LEFT JOIN DW.D_Stage dw_stg	ON ds_wfs.WorkFlowStageID = dw_stg.StageBusKey
		LEFT JOIN DW.D_Case dw_case ON ds_wfs.CaseID = dw_case.CaseBusKey
		LEFT JOIN DW.F_Case_Analysis dw_f_ca ON dw_f_ca.Case_Skey = dw_case.Case_Skey
		LEFT JOIN DW.D_Time dw_time_wfst ON convert(time,ds_wfs.WorkFlowStageStartDate) = dw_time_wfst.[Time]
		LEFT JOIN DW.D_Time dw_time_wfet ON convert(time,ds_wfs.WorkFlowStageEndDate) = dw_time_wfet.[Time]
WHERE	
	ds_cs.ProviderID <> 208
	AND ds_cs.Active = 1	

-- Update Existing Rows
CREATE TABLE stg.DW_LNK_Work_Flow_Stages_TEMP1
        WITH (clustered columnstore index, distribution = hash(Case_Analysis_Skey)) as

SELECT  dw.[Work_Flow_Stages_Skey]
	  ,stg.[Case_Analysis_Skey]
      ,stg.[Stage_Skey]
      ,stg.[WorkFlowStartDate_Skey]
      ,stg.[WorkFlowStartTime_Skey]
      ,stg.[WorkFlowEndDate_Skey]
      ,stg.[WorkFlowEndTime_Skey]
      ,stg.[StageOrder]
      ,stg.[Sys_LoadDate]
      ,stg.[Sys_ModifiedDate]
      ,stg.[Sys_RunID]
FROM stg.DW_LNK_Work_Flow_Stages_TEMP stg
	INNER JOIN DW.LNK_Work_Flow_Stages DW
		ON DW.Case_Analysis_Skey = stg.Case_Analysis_Skey
		AND DW.[Stage_Skey] = stg.[Stage_Skey]

-- -------------------------------------------------------------------
-- Second pass appends new rows to table
-- -------------------------------------------------------------------

-- Copy current table .. note distribution to REPLICATE
-- Update Existing Rows
CREATE TABLE stg.DW_LNK_Work_Flow_Stages_TEMP2
        WITH (clustered columnstore index, distribution = hash(Case_Analysis_Skey)) as

SELECT stg.[Work_Flow_Stages_Skey]
	  ,stg.[Case_Analysis_Skey]
      ,stg.[Stage_Skey]
      ,stg.[WorkFlowStartDate_Skey]
      ,stg.[WorkFlowStartTime_Skey]
      ,stg.[WorkFlowEndDate_Skey]
      ,stg.[WorkFlowEndTime_Skey]
      ,stg.[StageOrder]
      ,stg.[Sys_LoadDate]
      ,stg.[Sys_ModifiedDate]
      ,stg.[Sys_RunID]
FROM stg.DW_LNK_Work_Flow_Stages_TEMP1 stg

UNION ALL

SELECT cast(COALESCE((select max(Work_Flow_Stages_Skey) from stg.DW_LNK_Work_Flow_Stages_TEMP1),0) + row_number() over (order by getdate()) as int) as [Work_Flow_Stages_Skey]
	  ,stg.[Case_Analysis_Skey]
      ,stg.[Stage_Skey]
      ,stg.[WorkFlowStartDate_Skey]
      ,stg.[WorkFlowStartTime_Skey]
      ,stg.[WorkFlowEndDate_Skey]
      ,stg.[WorkFlowEndTime_Skey]
      ,stg.[StageOrder]
      ,stg.[Sys_LoadDate]
      ,stg.[Sys_ModifiedDate]
      ,stg.[Sys_RunID]
FROM stg.DW_LNK_Work_Flow_Stages_TEMP stg
	LEFT OUTER JOIN stg.DW_LNK_Work_Flow_Stages_TEMP1 stg_t1
		ON stg_t1.Case_Analysis_Skey = stg.Case_Analysis_Skey
		AND stg_t1.[Stage_Skey] = stg.[Stage_Skey]
WHERE stg_t1.Case_Analysis_Skey IS NULL

-- Create NOT NULL constraint on temp
alter table stg.DW_LNK_Work_Flow_Stages_TEMP2
ALTER COLUMN Work_Flow_Stages_Skey INT NOT NULL

-- Create primary key on temp
alter table stg.DW_LNK_Work_Flow_Stages_TEMP2
ADD CONSTRAINT PK_DW_LNK_Work_Flow_Stages PRIMARY KEY NONCLUSTERED (Work_Flow_Stages_Skey) NOT ENFORCED

---- Switch table contents replacing target with temp.

alter table DW.LNK_Work_Flow_Stages switch to OLD.DW_LNK_Work_Flow_Stages with (truncate_target=on);
alter table stg.DW_LNK_Work_Flow_Stages_TEMP2 switch to DW.LNK_Work_Flow_Stages with (truncate_target=on);

drop table stg.DW_LNK_Work_Flow_Stages_TEMP;
drop table stg.DW_LNK_Work_Flow_Stages_TEMP1;
drop table stg.DW_LNK_Work_Flow_Stages_TEMP2;

---- Force replication of table.
--select * from DW.[LNK_Work_Flow_Stages] order by 1;


--drop table DW.LNK_Work_Flow_Stages
--drop table OLD.DW_LNK_Work_Flow_Stages

--CREATE TABLE DW.LNK_Work_Flow_Stages
--        WITH (clustered columnstore index, distribution = hash(Case_Analysis_Skey)) 
--AS
--select * from stg.DW_LNK_Work_Flow_Stages_TEMP

--CREATE TABLE OLD.DW_LNK_Work_Flow_Stages
--        WITH (clustered columnstore index, distribution = hash(Case_Analysis_Skey)) 
--AS
--select * from stg.DW_LNK_Work_Flow_Stages_TEMP