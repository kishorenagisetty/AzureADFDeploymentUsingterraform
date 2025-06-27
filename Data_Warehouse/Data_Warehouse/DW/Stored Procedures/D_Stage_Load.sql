CREATE PROC [DW].[D_Stage_Load] AS


-- -------------------------------------------------------------------
-- Script:         DW.D_Stage Load
-- Target:         Azure Synapse Data Warehouse
-- -------------------------------------------------------------------

-- Delete temporary tables if present.

if object_id ('stg.DW_D_Stage_TEMP','U') is not null drop table stg.DW_D_Stage_TEMP;
if object_id ('stg.DW_D_Stage_TEMP1','U') is not null drop table stg.DW_D_Stage_TEMP1;
if object_id ('stg.DW_D_Stage_TEMP2','U') is not null drop table stg.DW_D_Stage_TEMP2;

-- -------------------------------------------------------------------
-- First pass creates new versions of changing rows.
-- -------------------------------------------------------------------

-- Get dataset from Data Store
CREATE TABLE stg.DW_D_Stage_TEMP
        with (clustered columnstore index, distribution = hash(StageBusKey))
AS

SELECT
	[WorkFlowStageID] AS [StageBusKey] ,
	[StageGroup] ,
	[StageCategory],
	[Stage] ,
	[StageOrder] ,
	[Sys_LoadDate],
	[Sys_ModifiedDate],
	[Sys_RunID]
FROM [DS].[Work_Flow_Stage]
OPTION (LABEL = 'CTAS : Load [dw].[D_Stage]')
;

-- Update Existing Rows
CREATE TABLE stg.DW_D_Stage_TEMP1
        WITH (clustered columnstore index, distribution = hash(StageBusKey)) as

SELECT 
	 dw.[Stage_Skey] ,
	stg.[StageBusKey] ,
	stg.[StageGroup] ,
	stg.[StageCategory],
	stg.[Stage] ,
	stg.[StageOrder] ,
	stg.[Sys_LoadDate],
	stg.[Sys_ModifiedDate],
	stg.[Sys_RunID]
FROM stg.DW_D_Stage_TEMP stg
	INNER JOIN DW.D_Stage DW
		ON DW.StageBusKey = stg.StageBusKey

-- -------------------------------------------------------------------
-- Second pass appends new rows to table
-- -------------------------------------------------------------------

-- Copy current table .. note distribution to REPLICATE

create  table stg.DW_D_Stage_TEMP2
        with (clustered columnstore index, distribution = replicate) as

SELECT
	-1				AS Stage_Skey,
	-1				AS [StageBusKey] ,
	'Not Available'	AS [StageGroup] ,
	'Not Available'	AS [StageCategory],
	'Not Available'	AS [Stage],
	-1				AS [StageOrder],
	--'N'			AS [Enquiry] ,
	--'N'			AS [Referral] ,
	--'N'			AS [TeleAssessment] ,
	--'N'			AS [InitialSupportPlan] ,
	--'N'			AS [PlanActive],
	--0			AS [DaysFrom],
	--0			AS [DaysTo],
	'1900-1-1'		AS Sys_LoadDate,
    '1900-1-1'		AS Sys_ModifiedDate,
	-1				AS Sys_RunID

UNION ALL

SELECT 
	stg.[Stage_Skey] ,
	stg.[StageBusKey] ,
	stg.[StageGroup] ,
	stg.[StageCategory],
	stg.[Stage] ,
	stg.[StageOrder] ,
	stg.[Sys_LoadDate],
	stg.[Sys_ModifiedDate],
	stg.[Sys_RunID]
FROM stg.DW_D_Stage_TEMP1 stg

UNION ALL

SELECT 
	cast(COALESCE((select max(Stage_Skey) from stg.DW_D_Stage_TEMP1),0) + row_number() over (order by getdate()) as int) as [Stage_Skey] ,
	stg.[StageBusKey] ,
	stg.[StageGroup] ,
	stg.[StageCategory],
	stg.[Stage] ,
	stg.[StageOrder] ,
	stg.[Sys_LoadDate],
	stg.[Sys_ModifiedDate],
	stg.[Sys_RunID]
from    stg.DW_D_Stage_TEMP stg
        left outer join stg.DW_D_Stage_TEMP1 stg_t1
        on stg_t1.StageBusKey = stg.StageBusKey
where   stg_t1.StageBusKey is null

-- Create NOT NULL constraint
alter table [STG].[DW_D_Stage_TEMP2]
ALTER COLUMN Stage_Skey INT NOT NULL

-- Create primary key 
 ALTER TABLE [STG].[DW_D_Stage_TEMP2]
 ADD CONSTRAINT PK_Stage_skey PRIMARY KEY NONCLUSTERED (Stage_Skey) NOT ENFORCED

-- Switch table contents replacing target with temp.

alter table DW.[D_Stage] switch to OLD.DW_D_Stage with (truncate_target=on);
alter table stg.DW_D_Stage_TEMP2 switch to DW.[D_Stage] with (truncate_target=on);

drop table stg.DW_D_Stage_TEMP;
drop table stg.DW_D_Stage_TEMP1;
drop table stg.DW_D_Stage_TEMP2;

-- Force replication of table.

--select  * from DW.[D_Stage] order by 1;
