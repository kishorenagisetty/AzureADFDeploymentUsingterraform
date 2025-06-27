CREATE VIEW [DV].[Dimension_Requestor] AS SELECT
	RequestorHash,
	RecordSource,
	RequestingOrganisation,
	RequestingOrganisation_AddressLine1,
	RequestingOrganisation_AddressLine2,
	RequestingOrganisation_Town,
	RequestingOrganisation_County,
	RequestingOrganisation_Country,
	RequestingOrganisation_PostCode,
	RequestingOrganisation_TelephoneNo,
	RequestingSite,
	RequestingSite_AddressLine1,
	RequestingSite_AddressLine2,
	RequestingSite_AddressLine3,
	RequestingSite_AddressLine4,
	RequestingSite_Town,
	RequestingSite_District,
	RequestingSiteContractAreaName,
	RequestingSite_County,
	RequestingSite_Country,
	RequestingSite_PostCode
FROM (
	SELECT
	RequestorHash,
	row_number() OVER (PARTITION BY RequestorHash ORDER BY RequestorHash) rn,
	RecordSource,
	RequestingOrganisation,
	RequestingOrganisation_AddressLine1,
	RequestingOrganisation_AddressLine2,
	RequestingOrganisation_Town,
	RequestingOrganisation_County,
	RequestingOrganisation_Country,
	RequestingOrganisation_PostCode,
	RequestingOrganisation_TelephoneNo,
	RequestingSite,
	RequestingSite_AddressLine1,
	RequestingSite_AddressLine2,
	RequestingSite_AddressLine3,
	RequestingSite_AddressLine4,
	RequestingSite_Town,
	RequestingSite_District,
	RequestingSiteContractAreaName,
	RequestingSite_County,
	RequestingSite_Country,
	RequestingSite_PostCode
	FROM DV.Base_Requestor
	) src
WHERE (rn = 1);
GO

