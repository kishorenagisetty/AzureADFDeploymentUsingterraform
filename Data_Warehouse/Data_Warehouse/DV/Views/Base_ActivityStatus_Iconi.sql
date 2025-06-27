CREATE VIEW [DV].[Base_ActivityStatus_Iconi]
AS SELECT DISTINCT
CONVERT(CHAR(66),CAST(HASHBYTES('SHA2_256',CAST(AC.ActivityStatus AS VARCHAR)) AS BINARY(32)),1) AS ActivityHash
,'ICONI.Meeting' AS RecordSource 
,AC.ActivityStatus AS ActivityStatus
,'0' AS ActivityStatusCode
FROM DV.SAT_Activity_Iconi_Core AC WHERE AC.ActivityStatus IS NOT NULL;
GO