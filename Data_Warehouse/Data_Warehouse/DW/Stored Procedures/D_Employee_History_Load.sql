CREATE PROC [DW].[D_Employee_History_Load] AS


-- -------------------------------------------------------------------
-- Script:         DW.D_Employee_History Load
-- Target:         Azure Synapse Data Warehouse
-- -------------------------------------------------------------------

-- Delete temporary tables if present.

if object_id ('stg.DW_D_Employee_History_TEMP','U') is not null drop table stg.DW_D_Employee_History_TEMP;
if object_id ('stg.DW_D_Employee_History_TEMP1','U') is not null drop table stg.DW_D_Employee_History_TEMP1;
if object_id ('stg.DW_D_Employee_History_TEMP2','U') is not null drop table stg.DW_D_Employee_History_TEMP2;

-- -------------------------------------------------------------------
-- First pass creates new versions of existing rows.
-- -------------------------------------------------------------------

-- Get dataset from Landing Zone
CREATE TABLE stg.DW_D_Employee_History_TEMP
        with (clustered columnstore index, distribution = hash(EmployeeHistoryBusKey))
AS

SELECT
	ds_eh.[EmployeeHistoryID] AS EmployeeHistoryBusKey,
	COALESCE(d_e.Employee_Skey,-1) AS Employee_Skey,
	ds_eh.[Start] AS SCD_Start,
	ds_eh.[End] AS SCD_End,
	COALESCE(NULLIF(ds_eh.[ReportsTo],''),'Not Set') AS ReportsTo,
	COALESCE(NULLIF(ds_eh.[WorksFor],''),'Not Set') AS WorksFor,
	COALESCE(NULLIF(ds_eh.[JobTitleBusKey],''),'Not Set') AS JobTitle,
	COALESCE(NULLIF(ds_e_p.[WorkEmail],''),'Not Set') AS WorksForWorkEmail,
	COALESCE(NULLIF(ds_eh.[Team],''),'Not Set') AS Team,
	ds_eh.[Sys_LoadDate],
    ds_eh.[Sys_ModifiedDate],
    ds_eh.[Sys_RunID]
FROM DS.Employee_History ds_eh
		LEFT JOIN DS.Employee ds_e
			ON ds_eh.EmployeeID = ds_e.EmployeeID
		LEFT JOIN DS.Employee ds_e_p
			ON ds_eh.WorksForEmployeeID = ds_e_p.EmployeeID
		LEFT JOIN DW.D_Employee d_e
			ON d_e.EmployeeBusKey = ds_e.EmployeeID

-- Update Existing Rows
CREATE TABLE stg.DW_D_Employee_History_TEMP1
        WITH (clustered columnstore index, distribution = hash(EmployeeHistoryBusKey)) as

SELECT
	 dw.EmployeeHistory_Skey,
	stg.EmployeeHistoryBusKey,
	stg.Employee_Skey,
	stg.SCD_Start,
	stg.SCD_End,
	stg.ReportsTo,
	stg.WorksFor,
	stg.JobTitle,
	stg.WorksForWorkEmail,
	stg.Team,
	stg.[Sys_LoadDate],
    stg.[Sys_ModifiedDate],
    stg.[Sys_RunID]
FROM stg.DW_D_Employee_History_TEMP stg
	INNER JOIN DW.D_Employee_History DW
		ON DW.EmployeeHistoryBusKey = stg.EmployeeHistoryBusKey

-- -------------------------------------------------------------------
-- Second pass appends new rows to table
-- -------------------------------------------------------------------

-- Copy current table .. note distribution to REPLICATE

create  table stg.DW_D_Employee_History_TEMP2
        with (clustered columnstore index, distribution = replicate) as

SELECT 
   -1 AS EmployeeHistory_Skey,
   -1 AS EmployeeHistoryBusKey,
   -1 AS Employee_Skey,
    '1900-1-1' AS SCD_Start,
    '9999-12-31' AS SCD_End,
	'Not Available' AS ReportsTo,
	'Not Available' AS WorksFor,
	'Not Available' AS JobTitle,
	'Not Available' AS WorksForWorkEmail,
	'Not Available' AS Team,
    '1900-1-1' AS Sys_LoadDate,
    '1900-1-1' AS Sys_ModifiedDate,
    -1 AS Sys_RunID

UNION ALL

SELECT
	stg.EmployeeHistory_Skey,
	stg.EmployeeHistoryBusKey,
	stg.Employee_Skey,
	stg.SCD_Start,
	stg.SCD_End,
	stg.ReportsTo,
	stg.WorksFor,
	stg.JobTitle,
	stg.WorksForWorkEmail,
	stg.Team,
	stg.[Sys_LoadDate],
    stg.[Sys_ModifiedDate],
    stg.[Sys_RunID]
FROM stg.DW_D_Employee_History_TEMP1 stg

UNION ALL

SELECT
	cast(COALESCE((select max(EmployeeHistory_Skey) from stg.DW_D_Employee_History_TEMP1),0) + row_number() over (order by getdate()) as int) as EmployeeHistory_Skey,
	stg.EmployeeHistoryBusKey,
	stg.Employee_Skey,
	stg.SCD_Start,
	stg.SCD_End,
	stg.ReportsTo,
	stg.WorksFor,
	stg.JobTitle,
	stg.WorksForWorkEmail,
	stg.Team,
	stg.[Sys_LoadDate],
    stg.[Sys_ModifiedDate],
    stg.[Sys_RunID]
FROM stg.DW_D_Employee_History_TEMP stg
        left outer join stg.DW_D_Employee_History_TEMP1 stg_t1
        on stg_t1.EmployeeHistoryBusKey = stg.EmployeeHistoryBusKey
where   stg_t1.EmployeeHistoryBusKey is null

-- Create NOT NULL constraint on temp
alter table stg.DW_D_Employee_History_TEMP2
ALTER COLUMN EmployeeHistory_Skey INT NOT NULL

-- Create primary key on temp
alter table stg.DW_D_Employee_History_TEMP2
ADD CONSTRAINT PK_DW_Employee_History PRIMARY KEY NONCLUSTERED (EmployeeHistory_Skey) NOT ENFORCED

-- Switch table contents replacing target with temp.

alter table DW.[D_Employee_History] switch to OLD.DW_D_Employee_History with (truncate_target=on);
alter table stg.DW_D_Employee_History_TEMP2 switch to DW.[D_Employee_History] with (truncate_target=on);

drop table stg.DW_D_Employee_History_TEMP;
drop table stg.DW_D_Employee_History_TEMP1;
drop table stg.DW_D_Employee_History_TEMP2;

-- Force replication of table.

--select  * from DW.[D_Employee_History] order by 1;
