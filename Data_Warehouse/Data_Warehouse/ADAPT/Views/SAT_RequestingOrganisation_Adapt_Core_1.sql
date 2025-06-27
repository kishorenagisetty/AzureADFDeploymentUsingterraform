CREATE VIEW [ADAPT].[SAT_RequestingOrganisation_Adapt_Core]
AS SELECT  
	RequestingOrganisationKey,
	RequestingOrganisation,
	AddressLine1,
	AddressLine2,
	Town,
	County,
	Country,
	PostCode,
	TelephoneNo,
	ValidFrom, ValidTo, IsCurrent
FROM (
	SELECT 
	TRIM(ORG_NAME) AS RequestingOrganisationKey,
	ORG_NAME AS RequestingOrganisation,
	ORG_LINE1 AS AddressLine1,
	ORG_LINE2 AS AddressLine2,
	ORG_TOWN AS Town,
	ORG_COUNTY AS County,
	ORG_COUNTRY AS Country,
	ORG_POSTCODE AS PostCode,
	ORG_PHONE AS TelephoneNo,
	ROW_NUMBER() OVER (PARTITION BY ORG_NAME ORDER BY REFERRAL_DT DESC) AS OrgRank,
	ValidFrom, ValidTo, IsCurrent
	FROM ADAPT.PROP_CAND_PRAP
	WHERE NULLIF(ORG_NAME,'') IS NOT NULL
) S WHERE OrgRank = 1;