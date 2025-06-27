CREATE VIEW [DV].[Base_Requestor_Default]
AS SELECT
	CONVERT(CHAR(66),CAST(0x0 AS BINARY(32)) ,1) AS RequestorHash,
	CAST('Unknown' AS VARCHAR(50)) AS RecordSource,
	CAST('Unknown' AS NVARCHAR(MAX)) RequestingOrganisation,
	CAST('Unknown' AS NVARCHAR(MAX)) RequestingOrganisation_AddressLine1,
	CAST('Unknown' AS NVARCHAR(MAX)) RequestingOrganisation_AddressLine2,
	CAST('Unknown' AS NVARCHAR(MAX)) RequestingOrganisation_Town,
	CAST('Unknown' AS NVARCHAR(MAX)) RequestingOrganisation_County,
	CAST('Unknown' AS NVARCHAR(MAX)) RequestingOrganisation_Country,
	CAST('Unknown' AS NVARCHAR(MAX)) RequestingOrganisation_PostCode,
	CAST('Unknown' AS NVARCHAR(MAX)) RequestingOrganisation_TelephoneNo,
	CAST('Unknown' AS NVARCHAR(MAX)) RequestingSite,
	CAST('Unknown' AS NVARCHAR(MAX)) RequestingSite_AddressLine1,
	CAST('Unknown' AS NVARCHAR(MAX)) RequestingSite_AddressLine2,
	CAST('Unknown' AS NVARCHAR(MAX)) RequestingSite_AddressLine3,
	CAST('Unknown' AS NVARCHAR(MAX)) RequestingSite_AddressLine4,
	CAST('Unknown' AS NVARCHAR(MAX)) RequestingSite_Town,
	CAST('Unknown' AS NVARCHAR(MAX)) RequestingSite_District,
	CAST('Unknown' AS NVARCHAR(MAX)) RequestingSiteContractAreaName,
	CAST('Unknown' AS NVARCHAR(MAX)) RequestingSite_County,
	CAST('Unknown' AS NVARCHAR(MAX)) RequestingSite_Country,
	CAST('Unknown' AS NVARCHAR(MAX)) RequestingSite_PostCode;
GO

