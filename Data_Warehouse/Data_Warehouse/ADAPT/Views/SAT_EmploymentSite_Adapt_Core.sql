CREATE VIEW [ADAPT].[SAT_EmploymentSite_Adapt_Core] 
AS 
-- Author: 
-- Create date: DD/MM/YYY
-- Ticket Reference:  <Dev Ops Ticket Reference>
-- Description: <Description regarding object>
-- Revisions:
-- DD/MM/YYY  - <>   - <#####> - <Initial Draft>
-- 19/10/2023 - <SK> - <29188> - <Adding 1 column related to IconiReference>
-- 22/11/2023 - <MK> - <30213> - <Site role type added to where clause to exclude orgs>
-- 24/11/2023 - <MK> - <30213> - <Sites excluded with delete status & Added Org ID>
With Latest_INDUSTRYSEC 
As
(
			
			Select t.*, mu1.[Description]
			From (
					Select Reference, INDUSTRY, Row_Number() Over (Partition by Reference Order by BISUNIQUEID Desc) as RN
					From [ADAPT].[PROP_IND_SECT] ISec 
					Where ISec.IsCurrent = 1
				) as t
			Inner Join ADAPT.CODES c On t.INDUSTRY = C.Code_ID
			Inner Join DV.SAT_References_MDMultiNames	mu1 on mu1.ID = C.CODE_ID and mu1.IsCurrent = 1  and mu1.Type = 'Code' 
			Where t.RN = 1 
			
)

SELECT 
	CONCAT_WS('|','ADAPT',CAST(C.REFERENCE AS INT))  AS EmploymentSiteKey,
	C.[NAME]										 AS EmploymentSiteName,
	C.[STATUS]										 AS EmploymentSiteStatus,
	C.WEB_ADD										 AS EmploymentSiteWebsiteAddress,
	CAST(C.[SOURCE] AS VARCHAR(MAX))				 AS EmploymentSiteSource,
	CAST(C.NO_EMPL	AS VARCHAR(MAX))				 AS EmploymentSiteNumberOfEmployees,
	C.[LOCATION]									 AS EmploymentSiteLocation,
	C.BLACKLIST									     AS EmploymentSiteBlacklisted,
	C.TRAD_NAME									     AS EmploymentSiteTradingName,
	C.REGION										 AS EmploymentSiteRegion,
	C.SIC											 AS EmploymentSiteSIC,
	C.COMP_INC										 AS EmploymentSiteIncorporationType,
	C.CRED_STAT									     AS EmploymentSiteCreditStatus,
	C.NLR											 AS EmploymentSiteManagedType,
	C2.REFERENCE									 AS EmploymentOrgKey, -- 24/11/23 <MK> <30213>
	C2.[Name]										 AS EmploymentOrgName,
	ISec.[Description]								 AS EmploymentJobSector,
	C.ACC_NUMBER									 AS IconiReference,-- 19/10/2023 - <SK> - <29188>
	C.ValidFrom										 AS ValidFrom,
	C.ValidTo										 AS ValidTo,
	C.IsCurrent										 AS IsCurrent

FROM
ADAPT.PROP_CLIENT_GEN AS C
Left JOIN ADAPT.PROP_X_ORG_SITE S 
On C.Reference = S.[Site] and S.IsCurrent = 1
Left Join ADAPT.PROP_CLIENT_GEN C2 
On S.[Org] = C2.Reference and C2.IsCurrent = 1
LEFT Join  Latest_INDUSTRYSEC ISec
On C2.Reference = ISec.REFERENCE
LEFT JOIN ADAPT.ENTITY_TABLE ET 
ON et.ENTITY_ID = C.REFERENCE and et.Iscurrent = 1 -- 24/11/23 <MK> <30213>
Where C.S_Role = 'Y' -- 22/11/23 <MK> <30213>
and	  et.Status <> 'D'; -- 24/11/23 <MK> <30213>
GO

