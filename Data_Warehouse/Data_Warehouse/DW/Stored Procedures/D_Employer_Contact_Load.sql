CREATE PROC [DW].[D_Employer_Contact_Load] AS


-- -------------------------------------------------------------------
-- Script:         DW.D_Employer_Contact Load
-- Target:         Azure Synapse Data Warehouse
-- -------------------------------------------------------------------

-- Delete temporary tables if present.

if object_id ('stg.DW_D_Employer_Contact_TEMP','U') is not null drop table stg.DW_D_Employer_Contact_TEMP;
if object_id ('stg.DW_D_Employer_Contact_TEMP1','U') is not null drop table stg.DW_D_Employer_Contact_TEMP1;
if object_id ('stg.DW_D_Employer_Contact_TEMP2','U') is not null drop table stg.DW_D_Employer_Contact_TEMP2;

-- -------------------------------------------------------------------
-- First pass creates new versions of rows.
-- -------------------------------------------------------------------

-- Get dataset from Data Store
CREATE TABLE stg.DW_D_Employer_Contact_TEMP
        with (clustered columnstore index, distribution = hash(EmployerContactBusKey))
AS

SELECT 
			DS_cont_r.ContactRoleID AS EmployerContactBusKey,
			COALESCE(NULLIF(DS_cont.ContactName,''),'Not Set') AS ContactName,
			DS_cont_r.ContactRole AS ContactRole,
			COALESCE(NULLIF(DS_cont.PhoneNumber,''),'Not Set') AS PhoneNumber,
			COALESCE(NULLIF(DS_cont.Email,''),'Not Set') AS Email,
			COALESCE(NULLIF(DS_cm.ContactMethod,''),'Not Set') AS ContactMethod,
			DS_cont_r.Sys_LoadDate,
			DS_cont_r.Sys_ModifiedDate,
			DS_cont_r.Sys_RunID
		from DS.Contact_Role DS_cont_r
			INNER JOIN DS.Contact DS_cont
				ON DS_cont_r.ContactID = DS_cont.ContactID
			LEFT JOIN DS.Contact_Method DS_cm
				ON DS_cont.ContactMethodID = DS_cm.ContactMethodID

-- Update Existing Rows
CREATE TABLE stg.DW_D_Employer_Contact_TEMP1
        WITH (clustered columnstore index, distribution = hash(EmployerContactBusKey)) as

SELECT
			dw.Employer_Contact_Skey,
			stg.EmployerContactBusKey,
			stg.ContactName,
			stg.ContactRole,
			stg.PhoneNumber,
			stg.Email,
			stg.ContactMethod,
			stg.Sys_LoadDate,
			stg.Sys_ModifiedDate,
			stg.Sys_RunID
FROM stg.DW_D_Employer_Contact_TEMP stg
	INNER JOIN DW.D_Employer_Contact DW
		ON DW.EmployerContactBusKey = stg.EmployerContactBusKey

-- -------------------------------------------------------------------
-- Second pass appends new rows to table
-- -------------------------------------------------------------------

-- Copy current table .. note distribution to REPLICATE

create  table stg.DW_D_Employer_Contact_TEMP2
        with (clustered columnstore index, distribution = replicate) as

SELECT
			stg.Employer_Contact_Skey,
			stg.EmployerContactBusKey,
			stg.ContactName,
			stg.ContactRole,
			stg.PhoneNumber,
			stg.Email,
			stg.ContactMethod,
			stg.Sys_LoadDate,
			stg.Sys_ModifiedDate,
			stg.Sys_RunID
FROM stg.DW_D_Employer_Contact_TEMP1 stg

UNION ALL

SELECT
			cast(COALESCE((select max(Employer_Contact_Skey) from stg.DW_D_Employer_Contact_TEMP1),0) + row_number() over (order by getdate()) as int) as Employer_Contact_Skey,
			stg.EmployerContactBusKey,
			stg.ContactName,
			stg.ContactRole,
			stg.PhoneNumber,
			stg.Email,
			stg.ContactMethod,
			stg.Sys_LoadDate,
			stg.Sys_ModifiedDate,
			stg.Sys_RunID
FROM stg.DW_D_Employer_Contact_TEMP stg
        left outer join stg.DW_D_Employer_Contact_TEMP1 stg_t1
        on stg_t1.EmployerContactBusKey = stg.EmployerContactBusKey
where   stg_t1.EmployerContactBusKey is null

-- Create NOT NULL constraint on temp
ALTER TABLE stg.DW_D_Employer_Contact_TEMP2
ALTER COLUMN Employer_Contact_Skey INT NOT NULL

-- Create primary key on temp
ALTER TABLE stg.DW_D_Employer_Contact_TEMP2
ADD CONSTRAINT PK_DW_Employer_Contact PRIMARY KEY NONCLUSTERED (Employer_Contact_Skey) NOT ENFORCED

-- Switch table contents replacing target with temp.

ALTER TABLE DW.[D_Employer_Contact] switch to OLD.DW_D_Employer_Contact with (truncate_target=on);
ALTER TABLE stg.DW_D_Employer_Contact_TEMP2 switch to DW.[D_Employer_Contact] with (truncate_target=on);

DROP TABLE stg.DW_D_Employer_Contact_TEMP;
DROP TABLE stg.DW_D_Employer_Contact_TEMP1;
DROP TABLE stg.DW_D_Employer_Contact_TEMP2;

-- Force replication of table.

--select  * from DW.[D_Employer_Contact] order by 1;