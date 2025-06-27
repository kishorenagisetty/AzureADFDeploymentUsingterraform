CREATE VIEW [DV].[Base_Requestor_Adapt]
AS SELECT
CONVERT(CHAR(66),CAST(
	HASHBYTES('SHA2_256',
		CONCAT(
			ISNULL(H_RO.RequestingOrganisationHash,CAST(0x0 AS BINARY(32))),
			ISNULL(H_RS.RequestingSiteHash, CAST(0x0 AS BINARY(32)))
		)
	) 
AS BINARY(32)) ,1) AS RequestorHash,
COALESCE(L_SO.RecordSource,H_RO.RecordSource) AS RecordSource,
NULLIF(S_ROC.RequestingOrganisation,'') AS RequestingOrganisation,
NULLIF(S_ROC.AddressLine1,'') AS RequestingOrganisation_AddressLine1,
NULLIF(S_ROC.AddressLine2,'') AS RequestingOrganisation_AddressLine2,
NULLIF(S_ROC.Town,'') AS RequestingOrganisation_Town,
NULLIF(S_ROC.County,'') AS RequestingOrganisation_County,
NULLIF(S_ROC.Country,'') AS RequestingOrganisation_Country,
NULLIF(S_ROC.PostCode,'') AS RequestingOrganisation_PostCode,
NULLIF(S_ROC.TelephoneNo,'') AS RequestingOrganisation_TelephoneNo,
NULLIF(S_RSC.RequestingSite,'') AS RequestingSite,
NULLIF(S_RSC.AddressLine1,'') AS RequestingSite_AddressLine1,
NULLIF(S_RSC.AddressLine2,'') AS RequestingSite_AddressLine2,
NULLIF(S_RSC.AddressLine3,'') AS RequestingSite_AddressLine3,
NULLIF(S_RSC.AddressLine4,'') AS RequestingSite_AddressLine4,
NULLIF(S_RSC.Town,'') AS RequestingSite_Town,
CAST(NULL AS NVARCHAR(MAX)) AS RequestingSite_District,
CAST(NULL AS NVARCHAR(MAX)) AS RequestingSiteContractAreaName,
NULLIF(S_RSC.County,'') AS RequestingSite_County,
NULLIF(S_RSC.Country,'') AS RequestingSite_Country,
NULLIF(S_RSC.PostCode,'') AS RequestingSite_PostCode
FROM DV.HUB_RequestingOrganisation H_RO
LEFT JOIN DV.LINK_RequestingSite_RequestingOrganisation L_SO ON L_SO.RequestingOrganisationHash = H_RO.RequestingOrganisationHash
LEFT JOIN DV.HUB_RequestingSite H_RS ON H_RS.RequestingSiteHash = L_SO.RequestingSiteHash
LEFT JOIN DV.SAT_RequestingOrganisation_Adapt_Core S_ROC ON S_ROC.RequestingOrganisationHash = H_RO.RequestingOrganisationHash and S_ROC.IsCurrent = 1
LEFT JOIN DV.SAT_RequestingSite_Adapt_Core S_RSC ON S_RSC.RequestingSiteHash = H_RS.RequestingSiteHash AND S_RSC.IsCurrent = 1
WHERE H_RO.RecordSource = 'ADAPT.PROP_CAND_PRAP';
GO

