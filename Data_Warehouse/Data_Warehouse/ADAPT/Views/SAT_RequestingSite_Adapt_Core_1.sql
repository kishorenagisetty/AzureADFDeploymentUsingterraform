CREATE VIEW [ADAPT].[SAT_RequestingSite_Adapt_Core]
AS SELECT  
	RequestingSiteKey,
	RequestingSite,
	AddressLine1,
	AddressLine2,
	AddressLine3,
	AddressLine4,
	Town,
	County,
	Country,
	PostCode,
	ValidFrom, ValidTo, IsCurrent
FROM (
	SELECT 
	TRIM(ST_LOCATION) AS RequestingSiteKey,
	ST_Location AS RequestingSite,
	ST_LINE1 AS AddressLine1,
	ST_LINE2 AS AddressLine2,
	ST_LINE3 AS AddressLine3,
	ST_LINE4 AS AddressLine4,
	ST_TOWN AS Town,
	ST_COUNTY AS County,
	ST_COUNTRY AS Country,
	ST_POSTCODE AS PostCode,
	ROW_NUMBER() OVER (PARTITION BY ST_LOCATION ORDER BY REFERRAL_DT DESC) AS SiteRank,
	ValidTo, ValidFrom, IsCurrent
	FROM ADAPT.PROP_CAND_PRAP
	WHERE NULLIF(ST_LOCATION,'') IS NOT NULL
) S WHERE SiteRank = 1;