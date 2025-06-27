CREATE PROC [DW].[D_Case_Load] AS


-- -------------------------------------------------------------------
-- Script:         DW.D_Case Load
-- Target:         Azure Synapse Data Warehouse
-- -------------------------------------------------------------------

-- Delete temporary tables if present.

if object_id ('stg.DW_D_Case_TEMP','U') is not null drop table stg.DW_D_Case_TEMP;
if object_id ('stg.DW_D_Case_TEMP1','U') is not null drop table stg.DW_D_Case_TEMP1;
if object_id ('stg.DW_D_Case_TEMP2','U') is not null drop table stg.DW_D_Case_TEMP2;

-- -------------------------------------------------------------------
-- Create new table
-- -------------------------------------------------------------------

-- Get dataset from Landing Zone
CREATE TABLE stg.DW_D_Case_TEMP
        with (clustered columnstore index, distribution = hash(CaseBusKey))
AS

SELECT
	c.CaseID AS CaseBusKey,
	c.CaseReferenceKey AS CaseReferenceID,
	COALESCE(NULLIF(cs.CaseSource,''),'Not Set') AS CaseSource,
	COALESCE(NULLIF(c.OtherReferralSource,''),'N/A') AS OtherReferralSource,
	CASE 
		WHEN c.OtherReferralSource LIKE 'HML Referral %' 
		THEN TRIM(
				 COALESCE(
						 STUFF(
							   SUBSTRING(c.OtherReferralSource
							            ,CHARINDEX('HML Referral',c.OtherReferralSource,1)+12
										,LEN(c.OtherReferralSource)
										)
							 , CHARINDEX('-'
							           ,SUBSTRING(c.OtherReferralSource
									             ,CHARINDEX('HML Referral',c.OtherReferralSource,1)+12
												 ,LEN(c.OtherReferralSource)
												 )
									   ,1
									   )
							  ,LEN('-')
							  , ''
							  )
							,SUBSTRING(c.OtherReferralSource
					            ,CHARINDEX('HML Referral',c.OtherReferralSource,1)+12
								,LEN(c.OtherReferralSource)
								      )
						)
				 )
		ELSE 'N/A'
	END AS ClinicianName,
	COALESCE(NULLIF(cc.CaseComplexity,''),'Not Set') AS CaseComplexity,
	COALESCE(NULLIF(c.PONumber,''),'Not Set') AS PONumber,
	c.ClientAttendingWork AS IsClientAttendingWork,
	c.IsVeterenReferral,
	c.IsReReferralCase,
	c.IsDirectReferral,
	c.IsCaseClosed,
	COALESCE(NULLIF(c.Occupation,''),'Not Set') AS  Occupation,
	COALESCE(NULLIF(JobTitle,''),'Not Set') AS  JobTitle,
	COALESCE(NULLIF(JobType,''),'Not Set') AS  JobType,
	COALESCE(HoursWorkedPerWeek,0) AS HoursWorkedPerWeek,
	IsApprentice,
	IsSelfEmployed,
	IsMentalHealthDisclosedToEmployer,
	c.Src_CreatedBy,
	c.Src_LastModifiedDate,
	c.Src_LastModifiedBy,
	c.Active,
	c.[Sys_LoadDate],
    c.[Sys_LoadExpiryDate],
	c.[Sys_IsCurrent],
    c.[Sys_RunID]
from
	DS.[Cases] c
	left join DS.Case_Source cs ON c.CaseSourceID = cs.CaseSourceID
	left join DS.Case_Complexity cc ON c.CaseComplexityID = cc.CaseComplexityID
WHERE
	c.ProviderID <> 208
	AND c.Active = 1

-- Update Existing Rows
CREATE TABLE stg.DW_D_Case_TEMP1
        WITH (clustered columnstore index, distribution = hash(CaseBusKey)) as

SELECT  DW.[Case_Skey] 
	  ,stg.[CaseBusKey]
      ,stg.[CaseReferenceID]
      ,stg.[CaseSource]
      ,stg.[OtherReferralSource]
      ,stg.[ClinicianName]
      ,stg.[CaseComplexity]
      ,stg.[PONumber]
      ,stg.[IsClientAttendingWork]
      ,stg.[IsVeterenReferral]
      ,stg.[IsReReferralCase]
      ,stg.[IsDirectReferral]
      ,stg.[IsCaseClosed]
      ,stg.[Occupation]
      ,stg.[JobTitle]
      ,stg.[JobType]
      ,stg.[HoursWorkedPerWeek]
      ,stg.[IsApprentice]
      ,stg.[IsSelfEmployed]
      ,stg.[IsMentalHealthDisclosedToEmployer]
      ,stg.[Src_CreatedBy]
      ,stg.[Src_LastModifiedDate]
      ,stg.[Src_LastModifiedBy]
      ,stg.[Active]
      ,stg.[Sys_LoadDate]
      ,stg.[Sys_LoadExpiryDate]
      ,stg.[Sys_IsCurrent]
      ,stg.[Sys_RunID]
  FROM [STG].[DW_D_Case_TEMP] stg
	INNER JOIN DW.D_Case DW
		ON DW.CaseBusKey = stg.CaseBusKey
-- -------------------------------------------------------------------
-- Second pass appends new rows to table
-- -------------------------------------------------------------------

-- Copy current table .. note distribution to REPLICATE
create  table stg.DW_D_Case_TEMP2
        with (clustered columnstore index, distribution = replicate) as

	SELECT 
   -1 AS Case_Skey,
   -1 AS CaseBusKey,
   0 AS CaseReferenceID,
	'Not Available' AS CaseSource,
   'Not Available' AS OtherReferralSource,
   'Not Available' AS ClinicianName,
   'Not Available' AS CaseComplexity,
   'Not Available' AS PONumber,
    CAST(0 AS BIT) AS IsClientAttendingWork,
	CAST(0 AS BIT) AS IsVeterenReferral,
	CAST(0 AS BIT) AS IsReReferralCase,
	CAST(0 AS BIT) AS IsDirectReferral,
	CAST(0 AS BIT) AS IsCaseClosed,
	'Not Available' AS  Occupation,
	'Not Available' AS  JobTitle,
	'Not Available' AS  JobType,
	0 AS HoursWorkedPerWeek,
	CAST(0 AS BIT) AS IsApprentice,
	CAST(0 AS BIT) AS IsSelfEmployed,
	CAST(0 AS BIT) AS IsMentalHealthDisclosedToEmployer,
	'DW_Load' AS Src_CreatedBy,
	'1900-01-01' AS Src_LastModifiedDate,
	'DW_Load' AS Src_LastModifiedBy,
	CAST(0 AS BIT) AS Active,
    '1900-1-1' AS Sys_LoadDate,
    '9999-12-31' AS Sys_LoadExpiryDate,
    CAST(1 AS BIT) AS Sys_IsCurrent,
    -1 AS Sys_RunID

UNION ALL

SELECT stg.[Case_Skey]
	  ,stg.[CaseBusKey]
      ,stg.[CaseReferenceID]
      ,stg.[CaseSource]
      ,stg.[OtherReferralSource]
      ,stg.[ClinicianName]
      ,stg.[CaseComplexity]
      ,stg.[PONumber]
      ,stg.[IsClientAttendingWork]
      ,stg.[IsVeterenReferral]
      ,stg.[IsReReferralCase]
      ,stg.[IsDirectReferral]
      ,stg.[IsCaseClosed]
      ,stg.[Occupation]
      ,stg.[JobTitle]
      ,stg.[JobType]
      ,stg.[HoursWorkedPerWeek]
      ,stg.[IsApprentice]
      ,stg.[IsSelfEmployed]
      ,stg.[IsMentalHealthDisclosedToEmployer]
      ,stg.[Src_CreatedBy]
      ,stg.[Src_LastModifiedDate]
      ,stg.[Src_LastModifiedBy]
      ,stg.[Active]
      ,stg.[Sys_LoadDate]
      ,stg.[Sys_LoadExpiryDate]
      ,stg.[Sys_IsCurrent]
      ,stg.[Sys_RunID]
  FROM [STG].[DW_D_Case_TEMP1] stg

UNION ALL

SELECT cast(COALESCE((select max(Case_Skey) from stg.DW_D_Case_TEMP1),0) + row_number() over (order by getdate()) as int) as Case_Skey
	  ,stg.[CaseBusKey]
      ,stg.[CaseReferenceID]
      ,stg.[CaseSource]
      ,stg.[OtherReferralSource]
      ,stg.[ClinicianName]
      ,stg.[CaseComplexity]
      ,stg.[PONumber]
      ,stg.[IsClientAttendingWork]
      ,stg.[IsVeterenReferral]
      ,stg.[IsReReferralCase]
      ,stg.[IsDirectReferral]
      ,stg.[IsCaseClosed]
      ,stg.[Occupation]
      ,stg.[JobTitle]
      ,stg.[JobType]
      ,stg.[HoursWorkedPerWeek]
      ,stg.[IsApprentice]
      ,stg.[IsSelfEmployed]
      ,stg.[IsMentalHealthDisclosedToEmployer]
      ,stg.[Src_CreatedBy]
      ,stg.[Src_LastModifiedDate]
      ,stg.[Src_LastModifiedBy]
      ,stg.[Active]
      ,stg.[Sys_LoadDate]
      ,stg.[Sys_LoadExpiryDate]
      ,stg.[Sys_IsCurrent]
      ,stg.[Sys_RunID]
  FROM [STG].[DW_D_Case_TEMP] stg
          left outer join stg.DW_D_Case_TEMP1 stg_t1
        on stg_t1.CaseBusKey = stg.CaseBusKey
where   stg_t1.CaseBusKey is null

-- Create NOT NULL constraint on temp
alter table stg.DW_D_Case_TEMP2
ALTER COLUMN Case_Skey INT NOT NULL

-- Create primary key on temp
alter table stg.DW_D_Case_TEMP2
ADD CONSTRAINT PK_DW_Case PRIMARY KEY NONCLUSTERED (Case_Skey) NOT ENFORCED

-- Switch table contents replacing target with temp.

alter table DW.[D_Case] switch to OLD.DW_D_Case with (truncate_target=on);
alter table stg.DW_D_Case_TEMP2 switch to DW.[D_Case] with (truncate_target=on);

drop table stg.DW_D_Case_TEMP;
drop table stg.DW_D_Case_TEMP1;
drop table stg.DW_D_Case_TEMP2;

-- Force replication of table.

--select  * from DW.[D_Case] order by 1;