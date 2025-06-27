CREATE PROC [DW].[F_Rota_History_Load] AS

-- -------------------------------------------------------------------
-- Script:         DW.F_Rota_History Load
-- Target:         Azure Synapse Data Warehouse
-- -------------------------------------------------------------------

-- Delete temporary tables if present.

if object_id ('stg.DW_F_Rota_History_TEMP','U')  is not null drop table stg.DW_F_Rota_History_TEMP;
if object_id ('stg.DW_F_Rota_History_TEMP1','U') is not null drop table stg.DW_F_Rota_History_TEMP1;
if object_id ('stg.DW_F_Rota_History_TEMP2','U') is not null drop table stg.DW_F_Rota_History_TEMP2;

-- -------------------------------------------------------------------
-- First pass creates new versions of existing rows.
-- -------------------------------------------------------------------

-- Get dataset from Data Store
CREATE TABLE stg.DW_F_Rota_History_TEMP
        WITH (clustered columnstore index, distribution = hash(RotaHistoryBusKey)) 
AS

SELECT
	  ds_rh.RotaHistoryID AS RotaHistoryBusKey
	, COALESCE(CAST(format(ds_rh.[Date],'yyyyMMdd') AS INT), -1) AS Date_Skey
	, COALESCE(d_emp.Employee_Skey,-1) AS Employee_Skey
	, COALESCE(d_st_time.Time_Skey,-1) AS Start_Time_Skey
	, COALESCE(d_end_time.Time_Skey,-1) AS End_Time_Skey
	, COALESCE(d_rt.RotaType_Skey,-1) AS RotaType_Skey
	, COALESCE(d_rht.RotaHistoryType_Skey,-1) AS RotaHistoryType_Skey
	, COALESCE(ds_rh.FTE_Daily,0) AS FTE_Daily
	, COALESCE(ds_rh.FTE_Monthly,0) AS FTE_Monthly
	, COALESCE(ds_rh.Duration,0) AS Duration
	, COALESCE(ds_rh.Productive_Duration,0) AS Productive_Duration
	, COALESCE(ds_rh.Productive_FTE_Daily,0) AS Productive_FTE_Daily
	, COALESCE(ds_rh.Productive_FTE_Monthly,0) AS Productive_FTE_Monthly
    , ds_rh.Sys_LoadDate
	, ds_rh.Sys_LoadExpiryDate
	, ds_rh.Sys_IsCurrent
FROM
	DS.Rota_History ds_rh
		LEFT JOIN DW.D_Employee d_emp ON ds_rh.EmployeeID = d_emp.EmployeeBusKey
		LEFT JOIN DW.D_Time d_st_time ON ds_rh.StartTime = d_st_time.[Time]
		LEFT JOIN DW.D_Time d_end_time ON ds_rh.EndTime = d_end_time.[Time]
		LEFT JOIN DW.D_Rota_Type d_rt ON ds_rh.RotaTypeID = d_rt.RotaTypeBusKey
		LEFT JOIN DW.D_Rota_History_Type d_rht ON ds_rh.RotaHistoryTypeID = d_rht.RotaHistoryTypeBusKey

-- Update Existing Rows
CREATE TABLE stg.DW_F_Rota_History_TEMP1
        WITH (clustered columnstore index, distribution = hash(RotaHistoryBusKey)) as

SELECT
	  dw.[Rota_History_Skey]
	, stg.[RotaHistoryBusKey]
	, stg.Date_Skey
	, stg.Employee_Skey
	, stg.Start_Time_Skey
	, stg.End_Time_Skey
	, stg.RotaType_Skey
	, stg.RotaHistoryType_Skey
	, stg.FTE_Daily
	, stg.FTE_Monthly
	, stg.Duration
	, stg.Productive_Duration
	, stg.Productive_FTE_Daily
	, stg.Productive_FTE_Monthly
    , stg.Sys_LoadDate
	, stg.Sys_LoadExpiryDate
	, stg.Sys_IsCurrent
FROM stg.DW_F_Rota_History_TEMP stg
	INNER JOIN DW.F_Rota_History DW
		ON DW.RotaHistoryBusKey = stg.RotaHistoryBusKey

-- -------------------------------------------------------------------
-- Second pass appends new rows to table
-- -------------------------------------------------------------------

-- Copy current table .. note distribution to hash

create  table stg.DW_F_Rota_History_TEMP2
        with (clustered columnstore index, distribution = hash(Employee_Skey)) as

SELECT
	  stg.[Rota_History_Skey]
	, stg.[RotaHistoryBusKey]
	, stg.Date_Skey
	, stg.Employee_Skey
	, stg.Start_Time_Skey
	, stg.End_Time_Skey
	, stg.RotaType_Skey
	, stg.RotaHistoryType_Skey
	, stg.FTE_Daily
	, stg.FTE_Monthly
	, stg.Duration
	, stg.Productive_Duration
	, stg.Productive_FTE_Daily
	, stg.Productive_FTE_Monthly
    , stg.Sys_LoadDate
	, stg.Sys_LoadExpiryDate
	, stg.Sys_IsCurrent
FROM stg.DW_F_Rota_History_TEMP1 stg

UNION ALL

-- Add new rows.
SELECT
	  cast(COALESCE((select max(Rota_History_Skey) from stg.DW_F_Rota_History_TEMP1),0) + row_number() over (order by getdate()) as int) as [Rota_History_Skey]
	, stg.[RotaHistoryBusKey]
	, stg.Date_Skey
	, stg.Employee_Skey
	, stg.Start_Time_Skey
	, stg.End_Time_Skey
	, stg.RotaType_Skey
	, stg.RotaHistoryType_Skey
	, stg.FTE_Daily
	, stg.FTE_Monthly
	, stg.Duration
	, stg.Productive_Duration
	, stg.Productive_FTE_Daily
	, stg.Productive_FTE_Monthly
    , stg.Sys_LoadDate
	, stg.Sys_LoadExpiryDate
	, stg.Sys_IsCurrent
from    stg.DW_F_Rota_History_TEMP stg
        left outer join stg.DW_F_Rota_History_TEMP1 stg_t1
        on stg_t1.RotaHistoryBusKey = stg.RotaHistoryBusKey
where   stg_t1.RotaHistoryBusKey is null

-- Create NOT NULL constraint on temp
alter table stg.DW_F_Rota_History_TEMP2
ALTER COLUMN Rota_History_Skey INT NOT NULL

-- Create primary key on temp
alter table stg.DW_F_Rota_History_TEMP2
ADD CONSTRAINT PK_DW_F_Rota_History PRIMARY KEY NONCLUSTERED (Rota_History_Skey) NOT ENFORCED

---- Switch table contents replacing target with temp.

alter table DW.F_Rota_History switch to OLD.DW_F_Rota_History with (truncate_target=on);
alter table stg.DW_F_Rota_History_TEMP2 switch to DW.F_Rota_History with (truncate_target=on);

drop table stg.DW_F_Rota_History_TEMP;
drop table stg.DW_F_Rota_History_TEMP1;
drop table stg.DW_F_Rota_History_TEMP2;

---- Force replication of table.
--select * from DW.[F_Rota_History] order by 1;


--drop table DW.F_Rota_History
--drop table OLD.DW_F_Rota_History

--CREATE TABLE DW.F_Rota_History
--        WITH (clustered columnstore index, distribution = hash(Employee_Skey)) 
--AS
--select 1 AS Rota_History_Skey, a.* from stg.DW_F_Rota_History_TEMP a where 1=0

--CREATE TABLE OLD.DW_F_Rota_History
--        WITH (clustered columnstore index, distribution = hash(Employee_Skey)) 
--AS
--select 1 AS Rota_History_Skey, a.* from stg.DW_F_Rota_History_TEMP a where 1=0