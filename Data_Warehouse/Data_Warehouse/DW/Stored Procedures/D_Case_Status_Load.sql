CREATE PROC [DW].[D_Case_Status_Load] AS


-- -------------------------------------------------------------------
-- Script:         DW.D_Case_Status Load
-- Target:         Azure Synapse Data Warehouse
-- -------------------------------------------------------------------

-- Delete temporary tables if present.

if object_id ('stg.DW_D_Case_Status_TEMP','U') is not null drop table stg.DW_D_Case_Status_TEMP;
if object_id ('stg.DW_D_Case_Status_TEMP1','U') is not null drop table stg.DW_D_Case_Status_TEMP1;
if object_id ('stg.DW_D_Case_Status_TEMP2','U') is not null drop table stg.DW_D_Case_Status_TEMP2;

-- -------------------------------------------------------------------
-- Create new table
-- -------------------------------------------------------------------

-- Get dataset from Landing Zone
CREATE TABLE stg.DW_D_Case_Status_TEMP
        with (clustered columnstore index, distribution = hash(CaseStatusBusKey))
AS

SELECT
	CaseStatusID AS CaseStatusBusKey,
	CaseStatus,
	CASE
		WHEN CaseStatus IN ('New Referral','Active Support') THEN 1
		ELSE 0
	END AS IsActiveCase,
	Active,
	[Sys_LoadDate],
    [Sys_ModifiedDate],
    [Sys_RunID]
FROM DS.Case_Status cs  

-- Update Existing Rows
CREATE TABLE stg.DW_D_Case_Status_TEMP1
        WITH (clustered columnstore index, distribution = hash(CaseStatusBusKey)) as

SELECT
	DW.Case_Status_Skey,
	stg.CaseStatusBusKey,
	stg.CaseStatus,
	stg.IsActiveCase,
	stg.Active,
	stg.[Sys_LoadDate],
    stg.[Sys_ModifiedDate],
    stg.[Sys_RunID]
FROM stg.DW_D_Case_Status_TEMP stg 
	INNER JOIN DW.D_Case_Status DW
		ON DW.CaseStatusBusKey = stg.CaseStatusBusKey

-- -------------------------------------------------------------------
-- Second pass appends new rows to table
-- -------------------------------------------------------------------

-- Copy current table .. note distribution to REPLICATE

create  table stg.DW_D_Case_Status_TEMP2
        with (clustered columnstore index, distribution = replicate) as

SELECT 
   -1 AS Case_Status_Skey,
   -1 AS CaseStatusBusKey,
	'Not Available' AS CaseStatus,
	CAST(0 AS BIT) AS IsActiveCase,
   CAST(0 AS BIT) AS Active,
    '1900-1-1' AS Sys_LoadDate,
    '1900-1-1' AS Sys_ModifiedDate,
    -1 AS Sys_RunID

UNION ALL

SELECT
	stg.Case_Status_Skey,
	stg.CaseStatusBusKey,
	stg.CaseStatus,
	stg.IsActiveCase,
	stg.Active,
	stg.[Sys_LoadDate],
    stg.[Sys_ModifiedDate],
    stg.[Sys_RunID]
FROM stg.DW_D_Case_Status_TEMP1 stg 

UNION ALL

-- Add new rows.
SELECT
	cast(COALESCE((select max(Case_Status_Skey) from stg.DW_D_Case_Status_TEMP1),0) + row_number() over (order by getdate()) as int) as Case_Status_Skey,
	stg.CaseStatusBusKey,
	stg.CaseStatus,
	stg.IsActiveCase,
	stg.Active,
	stg.[Sys_LoadDate],
    stg.[Sys_ModifiedDate],
    stg.[Sys_RunID]
FROM stg.DW_D_Case_Status_TEMP stg 
	LEFT OUTER JOIN stg.DW_D_Case_Status_TEMP1 stg_t1
	ON stg_t1.CaseStatusBusKey = stg.CaseStatusBusKey
where   stg_t1.CaseStatusBusKey is null

-- Create NOT NULL constraint on temp
alter table stg.DW_D_Case_Status_TEMP2
ALTER COLUMN Case_Status_Skey INT NOT NULL

-- Create primary key on temp
alter table stg.DW_D_Case_Status_TEMP2
ADD CONSTRAINT PK_DW_Case_Status PRIMARY KEY NONCLUSTERED (Case_Status_Skey) NOT ENFORCED

-- Switch table contents replacing target with temp.

alter table DW.[D_Case_Status] switch to OLD.DW_D_Case_Status with (truncate_target=on);
alter table stg.DW_D_Case_Status_TEMP2 switch to DW.[D_Case_Status] with (truncate_target=on);

drop table stg.DW_D_Case_Status_TEMP;
drop table stg.DW_D_Case_Status_TEMP1;
drop table stg.DW_D_Case_Status_TEMP2;

-- Force replication of table.

--select  * from DW.[D_Case_Status] order by 1;
