CREATE PROC [DW].[D_Employee_Load] AS


-- -------------------------------------------------------------------
-- Script:         DW.D_Employee Load
-- Target:         Azure Synapse Data Warehouse
-- -------------------------------------------------------------------

-- Delete temporary tables if present.

if object_id ('stg.DW_D_Employee_TEMP','U') is not null drop table stg.DW_D_Employee_TEMP;
if object_id ('stg.DW_D_Employee_TEMP1','U') is not null drop table stg.DW_D_Employee_TEMP1;
if object_id ('stg.DW_D_Employee_TEMP2','U') is not null drop table stg.DW_D_Employee_TEMP2;

-- -------------------------------------------------------------------
-- First pass creates new versions of changing rows.
-- -------------------------------------------------------------------

-- Get dataset from Landing Zone
CREATE TABLE stg.DW_D_Employee_TEMP
        with (clustered columnstore index, distribution = hash(EmployeeBusKey))
AS

SELECT
	[EmployeeID] AS EmployeeBusKey,
	COALESCE(NULLIF([CascadeEmployeeID],''),'Not Set') AS CascadeEmployeeID,
	COALESCE(NULLIF([FirstName],''),'Not Set')  AS FirstName,
	COALESCE(NULLIF([FullName],''),'Not Set')   AS FullName,
	COALESCE(NULLIF([LastName],''),'Not Set')   AS LastName,
	COALESCE(NULLIF(LegalEntity,''),'Not Set')  AS LegalEntity,
	COALESCE(NULLIF(EmployeeType,''),'Not Set') AS EmployeeType,
	COALESCE(NULLIF([WorkEmail],''),'Not Set')  AS WorkEmail ,
	COALESCE(NULLIF([PskUserID],''),'Not Set')  AS PskUserID ,
	COALESCE([Leaver],0)				        AS Leaver ,
	[Sys_LoadDate],
    [Sys_ModifiedDate],
    [Sys_RunID]
FROM [DS].[Employee] cs  

-- Update Existing Rows
CREATE TABLE stg.DW_D_Employee_TEMP1
        WITH (clustered columnstore index, distribution = hash(EmployeeBusKey)) as

SELECT
	DW.Employee_Skey,
	stg.EmployeeBusKey,
	stg.CascadeEmployeeID,
	stg.FirstName,
	stg.FullName,
	stg.LastName,
	stg.LegalEntity,
	stg.EmployeeType,
	stg.WorkEmail ,
	stg.PskUserID ,
	stg.Leaver ,
	stg.[Sys_LoadDate],
    stg.[Sys_ModifiedDate],
    stg.[Sys_RunID]
FROM stg.DW_D_Employee_TEMP stg
	INNER JOIN DW.D_Employee DW
		ON DW.EmployeeBusKey = stg.EmployeeBusKey
-- -------------------------------------------------------------------
-- Second pass appends new rows to table
-- -------------------------------------------------------------------

-- Copy current table .. note distribution to REPLICATE

create  table stg.DW_D_Employee_TEMP2
        with (clustered columnstore index, distribution = replicate) as

SELECT 
   -1 AS Employee_Skey,
   -1 AS EmployeeBusKey,
	'Not Available' AS CascadeEmployeeID,
	'Not Available' AS FirstName,
	'Not Available' AS FullName,
	'Not Available' AS LastName,
	'Not Available' AS LegalEntity,
	'Not Available' AS EmployeeType,
	'Not Available' AS WorkEmail,
	'Not Available' AS PskUserID,
	0 AS Leaver,
    '1900-1-1' AS Sys_LoadDate,
    '1900-1-1' AS Sys_ModifiedDate,
    -1 AS Sys_RunID

UNION ALL

SELECT
	stg.Employee_Skey,
	stg.EmployeeBusKey,
	stg.CascadeEmployeeID,
	stg.FirstName,
	stg.FullName,
	stg.LastName,
	stg.LegalEntity,
	stg.EmployeeType,
	stg.WorkEmail ,
	stg.PskUserID ,
	stg.Leaver ,
	stg.[Sys_LoadDate],
    stg.[Sys_ModifiedDate],
    stg.[Sys_RunID]
FROM stg.DW_D_Employee_TEMP1 stg

UNION ALL

SELECT
	cast(COALESCE((select max(Employee_Skey) from stg.DW_D_Employee_TEMP1),0) + row_number() over (order by getdate()) as int) as Employee_Skey,
	stg.EmployeeBusKey,
	stg.CascadeEmployeeID,
	stg.FirstName,
	stg.FullName,
	stg.LastName,
	stg.LegalEntity,
	stg.EmployeeType,
	stg.WorkEmail ,
	stg.PskUserID ,
	stg.Leaver ,
	stg.[Sys_LoadDate],
    stg.[Sys_ModifiedDate],
    stg.[Sys_RunID]
from    stg.DW_D_Employee_TEMP stg
        left outer join stg.DW_D_Employee_TEMP1 stg_t1
        on stg_t1.EmployeeBusKey = stg.EmployeeBusKey
where   stg_t1.EmployeeBusKey is null

-- Create NOT NULL constraint on temp
alter table stg.DW_D_Employee_TEMP2
ALTER COLUMN Employee_Skey INT NOT NULL

-- Create primary key on temp
alter table stg.DW_D_Employee_TEMP2
ADD CONSTRAINT PK_DW_Employee PRIMARY KEY NONCLUSTERED (Employee_Skey) NOT ENFORCED

-- Switch table contents replacing target with temp.

alter table DW.[D_Employee] switch to OLD.DW_D_Employee with (truncate_target=on);
alter table stg.DW_D_Employee_TEMP2 switch to DW.[D_Employee] with (truncate_target=on);

drop table stg.DW_D_Employee_TEMP;
drop table stg.DW_D_Employee_TEMP1;
drop table stg.DW_D_Employee_TEMP2;

-- Force replication of table.

--select  * from DW.[D_Employee] order by 1;