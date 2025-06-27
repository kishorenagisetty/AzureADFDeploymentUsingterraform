CREATE PROC [DW].[D_KPI_Load] AS

------ -------------------------------------------------------------------
------ Script:         DW.D_KPI Load (with version history)
------ Target:         Azure Synapse Data Warehouse
------ -------------------------------------------------------------------

------ Delete temporary tables if present.

if object_id ('stg.DW_D_KPI_TEMP','U')  is not null drop table stg.DW_D_KPI_TEMP;
if object_id ('stg.DW_D_KPI_TEMP1','U') is not null drop table stg.DW_D_KPI_TEMP1;
if object_id ('stg.DW_D_KPI_TEMP2','U') is not null drop table stg.DW_D_KPI_TEMP2;

-- -------------------------------------------------------------------
-- First TEMP table creates new versions of changing rows.
-- -------------------------------------------------------------------

-- Get dataset from Landing Zone
CREATE TABLE stg.DW_D_KPI_TEMP
        WITH (clustered columnstore index, distribution = hash(KPIBusKey)) 
AS

SELECT 
		  ext_kpi.[KPIReference]														AS  KPIBusKey
		, COALESCE(NULLIF(ext_kpi.[KPIArea],''),'Not Set')								AS	KPIArea
		, COALESCE(NULLIF(ext_kpi.[KPIName],''),'Not Set')								AS	KPIName
		, COALESCE(NULLIF(ext_kpi.[KPIDescriptionOfStandardRequired],''),'Not Set')		AS	KPIDescriptionOfStandardRequired
		, COALESCE(NULLIF(ext_kpi.[KPIType],''),'Not Set')								AS	KPIType
		, COALESCE(NULLIF(ext_kpi.[KPIStartType],''),'Not Set')							AS	KPIStartType
		, COALESCE(NULLIF(ext_kpi.[KPIStartEventType],''),'Not Set')					AS	KPIStartEventType				
		, COALESCE(NULLIF(ext_kpi.[KPIEndType],''),'Not Set')							AS	KPIEndType
		, COALESCE(NULLIF(ext_kpi.[KPIEndEventType],''),'Not Set')						AS	KPIEndEventType
		, COALESCE(NULLIF(ext_kpi.[KPIDurationType],''),'Not Set')						AS	KPIDurationType
		, COALESCE(       ext_kpi.[KPIDuration],0)										AS	KPIDuration
		, COALESCE(ext_kpi.[KPIGreenStart],0)											AS	KPIGreenStart
		, COALESCE(ext_kpi.[KPIGreenEnd],0)												AS	KPIGreenEnd
		, COALESCE(ext_kpi.[KPIAmberStart],0)											AS	KPIAmberStart
		, COALESCE(ext_kpi.[KPIAmberEnd],0)												AS	KPIAmberEnd
		, COALESCE(ext_kpi.[KPIRedStart],0)												AS	KPIRedStart
		, COALESCE(ext_kpi.[KPIRedEnd],0)												AS	KPIRedEnd
		, GETDATE()																		AS  Sys_LoadDate
		, GETDATE()																		AS  Sys_ModifiedDate
		--, CAST(
		--		 hashbytes(
		--				  'MD5',CONCAT_WS('|'							
		--									, COALESCE(LTRIM(RTRIM(ext_kpi.[KPIArea])),'')
		--									, COALESCE(LTRIM(RTRIM(ext_kpi.[KPIName])),'')
		--									, COALESCE(LTRIM(RTRIM(ext_kpi.[KPIDescriptionOfStandardRequired])),'')
		--									, COALESCE(LTRIM(RTRIM(ext_kpi.[KPIType])),'')
		--									, COALESCE(LTRIM(RTRIM(ext_kpi.[KPIStartType])),'')
		--									, COALESCE(LTRIM(RTRIM(ext_kpi.[KPIStartEventType])),'')
		--									, COALESCE(LTRIM(RTRIM(ext_kpi.[KPIEndType])),'')
		--									, COALESCE(LTRIM(RTRIM(ext_kpi.[KPIEndEventType])),'')
		--									, COALESCE(LTRIM(RTRIM(ext_kpi.[KPIDurationType])),'')
		--									, COALESCE(LTRIM(RTRIM(ext_kpi.[KPIDuration])),'')
		--									, COALESCE(LTRIM(RTRIM(ext_kpi.[KPIGreenStart])),'')
		--									, COALESCE(LTRIM(RTRIM(ext_kpi.[KPIGreenEnd])),'')
		--									, COALESCE(LTRIM(RTRIM(ext_kpi.[KPIAmberStart])),'')
		--									, COALESCE(LTRIM(RTRIM(ext_kpi.[KPIAmberEnd])),'')
		--									, COALESCE(LTRIM(RTRIM(ext_kpi.[KPIRedStart])),'')
		--									, COALESCE(LTRIM(RTRIM(ext_kpi.[KPIRedEnd])),'')
		--								 )
		--				 ) AS BINARY(16)
		--		  ) AS [Sys_HashKey]
		, CAST(-1 AS INT) AS Sys_RunID
FROM [ext].[D_KPI] ext_kpi

-- Append new versions of changing rows
CREATE TABLE stg.DW_D_KPI_TEMP1
        WITH (clustered columnstore index, distribution = hash(KPIBusKey)) as

SELECT
	  dw.KPI_Skey
	, stg.[KPIBusKey]
	, stg.[KPIArea]
	, stg.[KPIName]
	, stg.[KPIDescriptionOfStandardRequired]
	, stg.[KPIType]
	, stg.[KPIStartType]
	, stg.[KPIStartEventType]
	, stg.[KPIEndType]
	, stg.[KPIEndEventType]
	, stg.[KPIDurationType]
	, stg.[KPIDuration]
	, stg.[KPIGreenStart]
	, stg.[KPIGreenEnd]
	, stg.[KPIAmberStart]
	, stg.[KPIAmberEnd]
	, stg.[KPIRedStart]
	, stg.[KPIRedEnd]
	, dw.[Sys_LoadDate]
	, stg.[Sys_ModifiedDate]
	--, stg.[Sys_HashKey]
	, stg.[Sys_RunID]
FROM stg.DW_D_KPI_TEMP stg
	INNER JOIN DW.D_KPI DW
		ON DW.KPIBusKey = stg.KPIBusKey
--WHERE   stg.Sys_HashKey <> DW.Sys_HashKey

--UNION ALL

---- Append all previous unchanged rows --
--SELECT
--	  dw.KPI_Skey,
--	, dw.[KPIBusKey]
--	, dw.[KPIArea]
--	, dw.[KPIName]
--	, dw.[KPIDescriptionOfStandardRequired]
--	, dw.[KPIType]
--	, dw.[KPIStartType]
--	, dw.[KPIStartEventType]
--	, dw.[KPIEndType]
--	, dw.[KPIEndEventType]
--	, dw.[KPIDurationType]
--	, dw.[KPIDuration]
--	, dw.[KPIGreenStart]
--	, dw.[KPIGreenEnd]
--	, dw.[KPIAmberStart]
--	, dw.[KPIAmberEnd]
--	, dw.[KPIRedStart]
--	, dw.[KPIRedEnd]
--	, dw.[Sys_LoadDate]
--	, dw.[Sys_ModifiedDate]
--	, dw.[Sys_HashKey]
--FROM stg.DW_D_KPI_TEMP stg
--        INNER JOIN DW_D_KPI DW
--        on stg.KPIBusKey = DW.KPIBusKey
--        and stg.Sys_HashKey = dW.Sys_HashKey
--;
-- -------------------------------------------------------------------
-- Second pass appends new rows to table
-- -------------------------------------------------------------------

-- Copy current table .. note distribution to REPLICATE

create  table stg.DW_D_KPI_TEMP2
        with (clustered columnstore index, distribution = replicate) as

SELECT
	 -1 AS KPI_Skey
	,'Not Available' AS [KPIBusKey]
	,'Not Available' AS [KPIArea]
	,'Not Available' AS [KPIName]
	,'Not Available' AS [KPIDescriptionOfStandardRequired]
	,'Not Available' AS [KPIType]
	,'Not Available' AS [KPIStartType]
	,'Not Available' AS [KPIStartEventType]
	,'Not Available' AS [KPIEndType]
	,'Not Available' AS [KPIEndEventType]
	,'Not Available' AS [KPIDurationType]
	,0				 AS [KPIDuration]
	,0				 AS [KPIGreenStart]
	,0				 AS [KPIGreenEnd]
	,0				 AS [KPIAmberStart]
	,0				 AS [KPIAmberEnd]
	,0				 AS [KPIRedStart]
	,0				 AS [KPIRedEnd]
    ,'1900-1-1' AS Sys_LoadDate
    ,'1900-1-1' AS Sys_ModifiedDate
    ,-1 AS Sys_RunID

UNION ALL

select
	  stg.KPI_Skey
	, stg.[KPIBusKey]
	, stg.[KPIArea]
	, stg.[KPIName]
	, stg.[KPIDescriptionOfStandardRequired]
	, stg.[KPIType]
	, stg.[KPIStartType]
	, stg.[KPIStartEventType]
	, stg.[KPIEndType]
	, stg.[KPIEndEventType]
	, stg.[KPIDurationType]
	, stg.[KPIDuration]
	, stg.[KPIGreenStart]
	, stg.[KPIGreenEnd]
	, stg.[KPIAmberStart]
	, stg.[KPIAmberEnd]
	, stg.[KPIRedStart]
	, stg.[KPIRedEnd]
	, stg.[Sys_LoadDate]
	, stg.[Sys_ModifiedDate]
	--, stg.[Sys_HashKey]
	, stg.[Sys_RunID]
FROM    stg.DW_D_KPI_TEMP1 stg

UNION ALL
-- Add new rows.
select	  cast(COALESCE((select max(KPI_SKey) from stg.DW_D_KPI_TEMP1),0) + row_number() over (order by getdate()) as int) as KPI_Skey
		, stg.[KPIBusKey]
		, stg.[KPIArea]
		, stg.[KPIName]
		, stg.[KPIDescriptionOfStandardRequired]
		, stg.[KPIType]
		, stg.[KPIStartType]
		, stg.[KPIStartEventType]
		, stg.[KPIEndType]
		, stg.[KPIEndEventType]
		, stg.[KPIDurationType]
		, stg.[KPIDuration]
		, stg.[KPIGreenStart]
		, stg.[KPIGreenEnd]
		, stg.[KPIAmberStart]
		, stg.[KPIAmberEnd]
		, stg.[KPIRedStart]
		, stg.[KPIRedEnd]
		, stg.[Sys_LoadDate]
		, stg.[Sys_ModifiedDate]
	--, stg.[Sys_HashKey]
	, stg.[Sys_RunID]
from    stg.DW_D_KPI_TEMP stg
        left outer join stg.DW_D_KPI_TEMP1 stg_t1
        on stg_t1.KPIBusKey = stg.KPIBusKey
where   stg_t1.KPIBusKey is null

-- Create NOT NULL constraint on temp
alter table stg.DW_D_KPI_TEMP2
ALTER COLUMN KPI_SKey INT NOT NULL

-- Create primary key on temp
alter table stg.DW_D_KPI_TEMP2
ADD CONSTRAINT PK_DW_D_KPI PRIMARY KEY NONCLUSTERED (KPI_SKey) NOT ENFORCED

-- Switch table contents replacing target with temp.

alter table DW.D_KPI switch to OLD.DW_D_KPI with (truncate_target=on);
alter table stg.DW_D_KPI_TEMP2 switch to DW.D_KPI with (truncate_target=on);

drop table stg.DW_D_KPI_TEMP;
drop table stg.DW_D_KPI_TEMP1;
drop table stg.DW_D_KPI_TEMP2;

-- Force replication of table.
--select  * from DW.D_KPI order by KPI_Skey;