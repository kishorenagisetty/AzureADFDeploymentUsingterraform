CREATE VIEW [DV].[Base_ActivityType_Iconi]
AS SELECT
CONVERT(CHAR(66),[AT].ActivityTypeHash,1) AS ActivityTypeHash
,'ICONI.Meeting' AS RecordSource 
,S_ATC.ActivityType
,'0' AS ActivityTypeCode
,'Unknown' AS ActivityRole
,'Unknown' AS ActvitityCategory
FROM DV.HUB_ActivityType [AT]
LEFT JOIN DV.SAT_ActivityType_Iconi_Core S_ATC 
ON [AT].ActivityTypeKey = S_ATC.ActivityTypeKey
WHERE [AT].RecordSource = 'ICONI.ActivityType';
GO