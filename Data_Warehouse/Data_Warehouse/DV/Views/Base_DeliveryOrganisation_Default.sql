CREATE VIEW [DV].[Base_DeliveryOrganisation_Default]
AS SELECT 
CONVERT(CHAR(66),CAST(0x0 AS BINARY(32)) ,1) AS DeliveryOrganisationHash,
CAST('Unknown' AS VARCHAR(50)) AS RecordSource,
CAST(0 AS INT) AS AgencyContactDetailsId,
CAST('Unknown' AS NVARCHAR(MAX)) AS AgencyName,
CAST('Unknown' AS NVARCHAR(MAX)) AS AgencyShortName,
CAST(0 AS BIT) AS AgencyProvideService,
CAST(NULL AS NVARCHAR(MAX)) AS AgencyAddedDate,
CAST('Unknown' AS NVARCHAR(MAX)) AS AgencyNotes,
CAST('Unknown' AS NVARCHAR(MAX)) AS AgencyType,
CAST(NULL AS NVARCHAR(MAX)) AS AgencyLastUpdatedDate;
GO

