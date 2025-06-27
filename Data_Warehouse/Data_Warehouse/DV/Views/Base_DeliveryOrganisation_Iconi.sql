CREATE VIEW [DV].[Base_DeliveryOrganisation_Iconi]
AS SELECT
CONVERT(CHAR(66),P.DeliveryOrganisationHash ,1) AS DeliveryOrganisationHash
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
DV.HUB_DeliveryOrganisation P
LEFT JOIN DV.SAT_DeliveryOrganisation_Iconi_Core S_IP 
ON P.DeliveryOrganisationHash = S_IP.DeliveryOrganisationHash
WHERE P.RecordSource = 'ICONI.Agency';
GO

