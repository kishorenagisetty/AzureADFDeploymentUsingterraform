CREATE PROC [DW].[D_Attrition_Reason_Load] AS


-- -------------------------------------------------------------------
-- Script:         DW.D_Attrition_Reason Load
-- Target:         Azure Synapse Data Warehouse
-- -------------------------------------------------------------------

-- Delete temporary tables if present.

if object_id ('stg.DW_D_Attrition_Reason_TEMP','U') is not null drop table stg.DW_D_Attrition_Reason_TEMP;
if object_id ('stg.DW_D_Attrition_Reason_TEMP1','U') is not null drop table stg.DW_D_Attrition_Reason_TEMP1;
if object_id ('stg.DW_D_Attrition_Reason_TEMP2','U') is not null drop table stg.DW_D_Attrition_Reason_TEMP2;

-- -------------------------------------------------------------------
-- First pass creates new versions of changing rows.
-- -------------------------------------------------------------------

-- Get dataset from Landing Zone
CREATE TABLE stg.DW_D_Attrition_Reason_TEMP
        with (clustered columnstore index, distribution = hash(AttritionReasonBusKey))
AS

SELECT
	   [AttritionReasonID] AS AttritionReasonBusKey
      ,[AttritionType]
      ,[AttritionReason]
	  ,[Sys_LoadDate]
      ,[Sys_ModifiedDate]
      ,[Sys_RunID]
FROM DS.Attrition_Reason pr  

-- Update Existing Rows
CREATE TABLE stg.DW_D_Attrition_Reason_TEMP1
        WITH (clustered columnstore index, distribution = hash(AttritionReasonBusKey)) as

SELECT
	   DW.Attrition_Reason_Skey
	  ,stg.[AttritionReasonBusKey]
      ,stg.[AttritionType]
      ,stg.[AttritionReason]
	  ,stg.[Sys_LoadDate]
      ,stg.[Sys_ModifiedDate]
      ,stg.[Sys_RunID]
FROM stg.DW_D_Attrition_Reason_TEMP stg  
	INNER JOIN DW.D_Attrition_Reason DW
		ON DW.AttritionReasonBusKey = stg.AttritionReasonBusKey

-- -------------------------------------------------------------------
-- Second pass appends new rows to table
-- -------------------------------------------------------------------

-- Copy current table .. note distribution to REPLICATE

create  table stg.DW_D_Attrition_Reason_TEMP2
        with (clustered columnstore index, distribution = replicate) as

SELECT 
   -1 AS Attrition_Reason_Skey,
   -1 AS AttritionReasonBusKey,
	'Not Available' AS AttritionType,
	'Not Available' AS AttritionReason,
    '1900-1-1' AS Sys_LoadDate,
    '1900-1-1' AS Sys_ModifiedDate,
    -1 AS Sys_RunID

UNION ALL

SELECT
	   stg.Attrition_Reason_Skey
	  ,stg.[AttritionReasonBusKey]
      ,stg.[AttritionType]
      ,stg.[AttritionReason]
	  ,stg.[Sys_LoadDate]
      ,stg.[Sys_ModifiedDate]
      ,stg.[Sys_RunID]
FROM stg.DW_D_Attrition_Reason_TEMP1 stg  

UNION ALL

SELECT cast(COALESCE((select max(Attrition_Reason_Skey) from stg.DW_D_Attrition_Reason_TEMP1),0) + row_number() over (order by getdate()) as int) as Attrition_Reason_Skey
	  ,stg.[AttritionReasonBusKey]
      ,stg.[AttritionType]
      ,stg.[AttritionReason]
	  ,stg.[Sys_LoadDate]
      ,stg.[Sys_ModifiedDate]
      ,stg.[Sys_RunID]
from    stg.DW_D_Attrition_Reason_TEMP stg
        left outer join stg.DW_D_Attrition_Reason_TEMP1 stg_t1
        on stg_t1.AttritionReasonBusKey = stg.AttritionReasonBusKey
where   stg_t1.AttritionReasonBusKey is null

-- Create NOT NULL constraint on temp
alter table stg.DW_D_Attrition_Reason_TEMP2
ALTER COLUMN Attrition_Reason_Skey INT NOT NULL

-- Create primary key on temp
alter table stg.DW_D_Attrition_Reason_TEMP2
ADD CONSTRAINT PK_DW_Attrition_Reason PRIMARY KEY NONCLUSTERED (Attrition_Reason_Skey) NOT ENFORCED

-- Switch table contents replacing target with temp.

alter table DW.[D_Attrition_Reason] switch to OLD.DW_D_Attrition_Reason with (truncate_target=on);
alter table stg.DW_D_Attrition_Reason_TEMP2 switch to DW.[D_Attrition_Reason] with (truncate_target=on);

drop table stg.DW_D_Attrition_Reason_TEMP;
drop table stg.DW_D_Attrition_Reason_TEMP1;
drop table stg.DW_D_Attrition_Reason_TEMP2;

-- Force replication of table.

--select  * from DW.[D_Attrition_Reason] order by 1;
