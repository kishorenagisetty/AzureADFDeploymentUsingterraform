CREATE VIEW [DV].[Dimension_Provider]
AS SELECT 
CONVERT(CHAR(66),CAST(0x0 AS BINARY(32)) ,1) AS ProviderHash,
CAST('Unknown' AS VARCHAR(50)) AS RecordSource,
CAST(0 AS INT) AS AgencyContactDetailsId,
CAST('Unknown' AS NVARCHAR(MAX)) AS AgencyName,
CAST('Unknown' AS NVARCHAR(MAX)) AS AgencyShortName,
CAST(0 AS BIT) AS AgencyProvideService,
CAST(NULL AS NVARCHAR(MAX)) AS AgencyAddedDate,
CAST('Unknown' AS NVARCHAR(MAX)) AS AgencyNotes,
CAST('Unknown' AS NVARCHAR(MAX)) AS AgencyType,
CAST(NULL AS NVARCHAR(MAX)) AS AgencyLastUpdatedDate

UNION ALL

SELECT
CONVERT(CHAR(66),P.ProviderHash ,1) AS ProviderHash
,P.RecordSource
,S_IP.AgencyContactDetailsId
,S_IP.AgencyName
,S_IP.AgencyShortName
,S_IP.AgencyProvideService
,S_IP.AgencyAddedDate
,S_IP.AgencyNotes
,S_IP.AgencyType
,S_IP.AgencyLastUpdatedDate
FROM 
DV.HUB_Provider P
LEFT JOIN DV.SAT_Provider_Iconi_Core S_IP 
ON P.ProviderHash = S_IP.ProviderHash
WHERE P.RecordSource = 'ICONI.Agency';
GO

