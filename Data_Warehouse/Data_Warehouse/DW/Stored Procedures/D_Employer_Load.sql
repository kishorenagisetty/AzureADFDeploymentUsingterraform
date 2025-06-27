CREATE PROC [DW].[D_Employer_Load] AS


-- -------------------------------------------------------------------
-- Script:         DW.D_Employer Load
-- Target:         Azure Synapse Data Warehouse
-- -------------------------------------------------------------------

-- Delete temporary tables if present.

if object_id ('stg.DW_D_Employer_TEMP','U') is not null drop table stg.DW_D_Employer_TEMP;
if object_id ('stg.DW_D_Employer_TEMP1','U') is not null drop table stg.DW_D_Employer_TEMP1;
if object_id ('stg.DW_D_Employer_TEMP2','U') is not null drop table stg.DW_D_Employer_TEMP2;

-- -------------------------------------------------------------------
-- Create new table
-- -------------------------------------------------------------------

-- Get dataset from Landing Zone
CREATE TABLE stg.DW_D_Employer_TEMP
        with (clustered columnstore index, distribution = hash(EmployerBusKey))
AS

SELECT 
			DS_org_r.OrganisationRoleID AS EmployerBusKey,
			COALESCE(NULLIF(DS_org.OrganisationName,''),'Not Set') AS EmployerName,
			COALESCE(NULLIF(DS_org_sz.OrganisationSize,''),'Not Set') AS EmployerSize,
			COALESCE(NULLIF(DS_org_tp.OrganisationType,''),'Not Set') AS EmployerType,
			COALESCE(NULLIF(DS_org_se.OrganisationSector,''),'Not Set') AS EmployerSector,
			DS_org_r.OrganisationRole AS EmployerRole,
			DS_org_r.Sys_LoadDate,
			DS_org_r.Sys_ModifiedDate,
			DS_org_r.Sys_RunID
		from DS.Organisation_Role DS_org_r
			INNER JOIN DS.Organisation DS_org
				ON DS_org_r.OrganisationID = DS_org.OrganisationID
			LEFT JOIN DS.Organisation_Size DS_org_sz
				ON DS_org.OrganisationSizeID = DS_org_sz.OrganisationSizeID
			LEFT JOIN DS.Organisation_Type DS_org_tp
				ON DS_org.OrganisationTypeID = DS_org_tp.OrganisationTypeID
			LEFT JOIN DS.Organisation_Sector DS_org_se
				ON DS_org.OrganisationSectorID = DS_org_se.OrganisationSectorID

-- Update Existing Rows
CREATE TABLE stg.DW_D_Employer_TEMP1
        WITH (clustered columnstore index, distribution = hash(EmployerBusKey)) as

SELECT
		DW.Employer_Skey,
		stg.EmployerBusKey,
		stg.EmployerName,
		stg.EmployerSize,
		stg.EmployerType,
		stg.EmployerSector,
		stg.EmployerRole,
		stg.Sys_LoadDate,
		stg.Sys_ModifiedDate,
		stg.Sys_RunID
FROM stg.DW_D_Employer_TEMP stg
	INNER JOIN DW.D_Employer DW
		ON DW.EmployerBusKey = stg.EmployerBusKey

-- -------------------------------------------------------------------
-- Second pass appends new rows to table
-- -------------------------------------------------------------------

-- Copy current table .. note distribution to REPLICATE

create  table stg.DW_D_Employer_TEMP2
        with (clustered columnstore index, distribution = replicate) as

SELECT
		stg.Employer_Skey,
		stg.EmployerBusKey,
		stg.EmployerName,
		stg.EmployerSize,
		stg.EmployerType,
		stg.EmployerSector,
		stg.EmployerRole,
		stg.Sys_LoadDate,
		stg.Sys_ModifiedDate,
		stg.Sys_RunID
FROM stg.DW_D_Employer_TEMP1 stg

UNION ALL

SELECT
		cast(COALESCE((select max(Employer_Skey) from stg.DW_D_Employer_TEMP1),0) + row_number() over (order by getdate()) as int) as Employer_Skey,
		stg.EmployerBusKey,
		stg.EmployerName,
		stg.EmployerSize,
		stg.EmployerType,
		stg.EmployerSector,
		stg.EmployerRole,
		stg.Sys_LoadDate,
		stg.Sys_ModifiedDate,
		stg.Sys_RunID
FROM stg.DW_D_Employer_TEMP stg
        left outer join stg.DW_D_Employer_TEMP1 stg_t1
        on stg_t1.EmployerBusKey = stg.EmployerBusKey
where   stg_t1.EmployerBusKey is null

-- Create NOT NULL constraint on temp
ALTER TABLE stg.DW_D_Employer_TEMP2
ALTER COLUMN Employer_Skey INT NOT NULL

-- Create primary key on temp
ALTER TABLE stg.DW_D_Employer_TEMP2
ADD CONSTRAINT PK_DW_Employer PRIMARY KEY NONCLUSTERED (Employer_Skey) NOT ENFORCED

-- Switch table contents replacing target with temp.

ALTER TABLE DW.[D_Employer] switch to OLD.DW_D_Employer with (truncate_target=on);
ALTER TABLE stg.DW_D_Employer_TEMP2 switch to DW.[D_Employer] with (truncate_target=on);

DROP TABLE stg.DW_D_Employer_TEMP;
DROP TABLE stg.DW_D_Employer_TEMP1;
DROP TABLE stg.DW_D_Employer_TEMP2;

-- Force replication of table.

--select  * from DW.[D_Employer] order by 1;
