CREATE PROC [DW].[D_Programme_Load] AS


-- -------------------------------------------------------------------
-- Script:         DW.D_Programme Load
-- Target:         Azure Synapse Data Warehouse
-- -------------------------------------------------------------------

-- Delete temporary tables if present.

if object_id ('stg.DW_D_Programme_TEMP','U') is not null drop table stg.DW_D_Programme_TEMP;
if object_id ('stg.DW_D_Programme_TEMP1','U') is not null drop table stg.DW_D_Programme_TEMP1;
if object_id ('stg.DW_D_Programme_TEMP2','U') is not null drop table stg.DW_D_Programme_TEMP2;

-- -------------------------------------------------------------------
-- Create new table
-- -------------------------------------------------------------------

-- Get dataset from Landing Zone
CREATE TABLE stg.DW_D_Programme_TEMP
        with (clustered columnstore index, distribution = hash(ProgrammeBusKey))
AS

SELECT
	   [ProgrammeID] AS ProgrammeBusKey
      ,[Programme]
      ,[ProgrammeGroup]
      ,[ProgrammeCategory]
      ,[ProgrammeStartDate]
      ,ISNULL([ProgrammeEndDate],'9999-12-31') AS ProgrammeEndDate
      ,[IsActive]
	  ,[Sys_LoadDate]
      ,[Sys_ModifiedDate]
      ,[Sys_RunID]
FROM DS.Programme pr  

-- Update Existing Rows
CREATE TABLE stg.DW_D_Programme_TEMP1
        WITH (clustered columnstore index, distribution = hash(ProgrammeBusKey)) as

SELECT
	    dw.Programme_Skey
	  ,stg.ProgrammeBusKey
      ,stg.[Programme]
      ,stg.[ProgrammeGroup]
      ,stg.[ProgrammeCategory]
      ,stg.[ProgrammeStartDate]
      ,stg.ProgrammeEndDate
      ,stg.[IsActive]
	  ,stg.[Sys_LoadDate]
      ,stg.[Sys_ModifiedDate]
      ,stg.[Sys_RunID]
FROM stg.DW_D_Programme_TEMP stg
	INNER JOIN DW.D_Programme DW
		ON DW.ProgrammeBusKey = stg.ProgrammeBusKey

-- -------------------------------------------------------------------
-- Second pass appends new rows to table
-- -------------------------------------------------------------------

-- Copy current table .. note distribution to REPLICATE

create  table stg.DW_D_Programme_TEMP2
        with (clustered columnstore index, distribution = replicate) as

SELECT 
   -1 AS Programme_Skey,
   -1 AS ProgrammeBusKey,
	'Not Available' AS Programme,
	'Not Available' AS ProgrammeGroup,
	'Not Available' AS ProgrammeCategory,
	'1900-1-1' AS ProgrammeStartDate,
	'9999-12-31' AS ProgrammeEndDate,
	CAST(0 AS BIT) AS IsActive,
    '1900-1-1' AS Sys_LoadDate,
    '1900-1-1' AS Sys_ModifiedDate,
    -1 AS Sys_RunID

UNION ALL

SELECT
	   stg.Programme_Skey
	  ,stg.ProgrammeBusKey
      ,stg.[Programme]
      ,stg.[ProgrammeGroup]
      ,stg.[ProgrammeCategory]
      ,stg.[ProgrammeStartDate]
      ,stg.ProgrammeEndDate
      ,stg.[IsActive]
	  ,stg.[Sys_LoadDate]
      ,stg.[Sys_ModifiedDate]
      ,stg.[Sys_RunID]
FROM stg.DW_D_Programme_TEMP1 stg

UNION ALL

SELECT
	   cast(COALESCE((select max(Programme_Skey) from stg.DW_D_Programme_TEMP1),0) + row_number() over (order by getdate()) as int) as Programme_Skey
	  ,stg.ProgrammeBusKey
      ,stg.[Programme]
      ,stg.[ProgrammeGroup]
      ,stg.[ProgrammeCategory]
      ,stg.[ProgrammeStartDate]
      ,stg.ProgrammeEndDate
      ,stg.[IsActive]
	  ,stg.[Sys_LoadDate]
      ,stg.[Sys_ModifiedDate]
      ,stg.[Sys_RunID]
FROM stg.DW_D_Programme_TEMP stg
        left outer join stg.DW_D_Programme_TEMP1 stg_t1
        on stg_t1.ProgrammeBusKey = stg.ProgrammeBusKey
where   stg_t1.ProgrammeBusKey is null


-- Create NOT NULL constraint on temp
alter table stg.DW_D_Programme_TEMP2
ALTER COLUMN Programme_Skey INT NOT NULL

-- Create primary key on temp
alter table stg.DW_D_Programme_TEMP2
ADD CONSTRAINT PK_DW_Programme PRIMARY KEY NONCLUSTERED (Programme_Skey) NOT ENFORCED

-- Switch table contents replacing target with temp.

alter table DW.[D_Programme] switch to OLD.DW_D_Programme with (truncate_target=on);
alter table stg.DW_D_Programme_TEMP2 switch to DW.[D_Programme] with (truncate_target=on);

drop table stg.DW_D_Programme_TEMP;
drop table stg.DW_D_Programme_TEMP1;
drop table stg.DW_D_Programme_TEMP2;

-- Force replication of table.

--select  * from DW.[D_Programme] order by 1;