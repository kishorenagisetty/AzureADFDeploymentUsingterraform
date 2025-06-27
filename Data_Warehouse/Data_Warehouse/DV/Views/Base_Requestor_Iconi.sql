CREATE VIEW [DV].[Base_Requestor_Iconi]
AS SELECT

CONVERT(CHAR(66),CAST(
	HASHBYTES('SHA2_256',
			ISNULL(H_RS.RequestingSiteHash,CAST(0x0 AS BINARY(32)))
	) 
AS BINARY(32)) ,1) AS RequestorHash,
H_RS.RecordSource,
CAST(NULL AS NVARCHAR(MAX)) AS RequestingOrganisation,
CAST(NULL AS NVARCHAR(MAX)) AS RequestingOrganisation_AddressLine1,
CAST(NULL AS NVARCHAR(MAX)) AS RequestingOrganisation_AddressLine2,
CAST(NULL AS NVARCHAR(MAX)) AS RequestingOrganisation_Town,
CAST(NULL AS NVARCHAR(MAX)) AS RequestingOrganisation_County,
CAST(NULL AS NVARCHAR(MAX)) AS RequestingOrganisation_Country,
CAST(NULL AS NVARCHAR(MAX)) AS RequestingOrganisation_PostCode,
CAST(NULL AS NVARCHAR(MAX)) AS RequestingOrganisation_TelephoneNo,
S_RS.RequestingSiteName AS RequestingSite,
CAST(NULL AS NVARCHAR(MAX)) AS RequestingSite_AddressLine1,
CAST(NULL AS NVARCHAR(MAX)) AS RequestingSite_AddressLine2,
CAST(NULL AS NVARCHAR(MAX)) AS RequestingSite_AddressLine3,
CAST(NULL AS NVARCHAR(MAX)) AS RequestingSite_AddressLine4,
CAST(NULL AS NVARCHAR(MAX)) AS RequestingSite_Town,
S_RS.RequestingSiteDistrict AS RequestingSiteDistrictName,
S_RS.RequestingSiteContractAreaName AS RequestingSiteContractAreaName,
CAST(NULL AS NVARCHAR(MAX)) AS RequestingSite_County,
CAST(NULL AS NVARCHAR(MAX)) AS RequestingSite_Country,
CAST(NULL AS NVARCHAR(MAX)) AS RequestingSite_PostCode
FROM DV.HUB_RequestingSite H_RS
LEFT JOIN DV.SAT_RequestingSite_Iconi_Core S_RS ON H_RS.RequestingSiteHash = S_RS.RequestingSiteHash
WHERE H_RS.RecordSource = 'ICONI.Engagement';
GO

