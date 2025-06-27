CREATE PROC [DW].[F_Rota_History_Combined_Load] AS

-- -------------------------------------------------------------------
-- Script:         DW.F_Rota_Combined_History Load
-- Target:         Azure Synapse Data Warehouse
-- -------------------------------------------------------------------

-- Delete temporary tables if present.

if object_id ('stg.DW_F_Rota_History_Combined_TEMP','U')  is not null drop table stg.DW_F_Rota_History_Combined_TEMP;
-- Delete temporary tables if present.

---- -------------------------------------------------------------------
---- Create new table
---- -------------------------------------------------------------------

CREATE TABLE stg.DW_F_Rota_History_Combined_TEMP
        WITH (clustered columnstore index, distribution = hash(Employee_Skey)) 
AS

SELECT
	  row_number() over (order by getdate()) AS Rota_History_Combined_Skey
	, COALESCE(CAST(format(ds_rh.[Date],'yyyyMMdd') AS INT), -1) AS Date_Skey
	, COALESCE(d_emp.Employee_Skey,-1) AS Employee_Skey
	, COALESCE(d_st_time.Time_Skey,-1) AS Start_Time_Skey
	, COALESCE(d_end_time.Time_Skey,-1) AS End_Time_Skey
	, COALESCE(d_rt.RotaType_Skey,-1) AS RotaType_Skey
	, MAX(CASE WHEN d_rht.RotaHistoryType = 'Planned' THEN COALESCE(ds_rh.FTE_Daily,0)				ELSE 0 END) AS Planned_FTE_Daily
	, MAX(CASE WHEN d_rht.RotaHistoryType = 'Planned' THEN COALESCE(ds_rh.FTE_Monthly,0)			ELSE 0 END) AS Planned_FTE_Monthly
	, MAX(CASE WHEN d_rht.RotaHistoryType = 'Planned' THEN COALESCE(ds_rh.Duration,0)				ELSE 0 END) AS Planned_Duration
	, MAX(CASE WHEN d_rht.RotaHistoryType = 'Planned' THEN COALESCE(ds_rh.Productive_Duration,0)	ELSE 0 END) AS Planned_Productive_Duration
	, MAX(CASE WHEN d_rht.RotaHistoryType = 'Planned' THEN COALESCE(ds_rh.Productive_FTE_Daily,0)	ELSE 0 END) AS Planned_Productive_FTE_Daily
	, MAX(CASE WHEN d_rht.RotaHistoryType = 'Planned' THEN COALESCE(ds_rh.Productive_FTE_Monthly,0) ELSE 0 END) AS Planned_Productive_FTE_Monthly
	, MAX(CASE WHEN d_rht.RotaHistoryType = 'Actual'  THEN COALESCE(ds_rh.FTE_Daily,0)				ELSE 0 END) AS Actual_FTE_Daily
	, MAX(CASE WHEN d_rht.RotaHistoryType = 'Actual'  THEN COALESCE(ds_rh.FTE_Monthly,0)			ELSE 0 END) AS Actual_FTE_Monthly
	, MAX(CASE WHEN d_rht.RotaHistoryType = 'Actual'  THEN COALESCE(ds_rh.Duration,0)				ELSE 0 END) AS Actual_Duration
	, MAX(CASE WHEN d_rht.RotaHistoryType = 'Actual'  THEN COALESCE(ds_rh.Productive_Duration,0)	ELSE 0 END) AS Actual_Productive_Duration
	, MAX(CASE WHEN d_rht.RotaHistoryType = 'Actual'  THEN COALESCE(ds_rh.Productive_FTE_Daily,0)	ELSE 0 END) AS Actual_Productive_FTE_Daily
	, MAX(CASE WHEN d_rht.RotaHistoryType = 'Actual'  THEN COALESCE(ds_rh.Productive_FTE_Monthly,0) ELSE 0 END) AS Actual_Productive_FTE_Monthly
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
GROUP BY
	  COALESCE(CAST(format(ds_rh.[Date],'yyyyMMdd') AS INT), -1)
	, COALESCE(d_emp.Employee_Skey,-1)
	, COALESCE(d_st_time.Time_Skey,-1)
	, COALESCE(d_end_time.Time_Skey,-1)
	, COALESCE(d_rt.RotaType_Skey,-1)
	, ds_rh.Sys_LoadDate
	, ds_rh.Sys_LoadExpiryDate
	, ds_rh.Sys_IsCurrent

-- Create NOT NULL constraint on temp
alter table stg.DW_F_Rota_History_Combined_TEMP
ALTER COLUMN Rota_History_Combined_Skey INT NOT NULL

-- Create primary key on temp
alter table stg.DW_F_Rota_History_Combined_TEMP
ADD CONSTRAINT PK_DW_F_Rota_History_Combined PRIMARY KEY NONCLUSTERED (Rota_History_Combined_Skey) NOT ENFORCED

---- Switch table contents replacing target with temp.

alter table DW.F_Rota_History_Combined switch to OLD.DW_F_Rota_History_Combined with (truncate_target=on);
alter table stg.DW_F_Rota_History_Combined_TEMP switch to DW.F_Rota_History_Combined with (truncate_target=on);

drop table stg.DW_F_Rota_History_Combined_TEMP;

---- Force replication of table.
--select * from DW.[F_Rota_History_Combined] order by 1;


--drop table DW.F_Rota_History_Combined
--drop table OLD.DW_F_Rota_History_Combined

--CREATE TABLE DW.F_Rota_History_Combined
--        WITH (clustered columnstore index, distribution = hash(Employee_Skey)) 
--AS
--select a.* from stg.DW_F_Rota_History_Combined_TEMP a where 1=0

--CREATE TABLE OLD.DW_F_Rota_History_Combined
--        WITH (clustered columnstore index, distribution = hash(Employee_Skey)) 
--AS
--select a.* from stg.DW_F_Rota_History_Combined_TEMP a where 1=0