CREATE VIEW [ICONI].[SAT_ActivityType_Iconi_Core] AS SELECT DISTINCT
CONCAT_WS('|','ICONI', M.meet_type) AS ActivityTypeKey,
M.meet_type AS ActivityType,
cast('1900-01-02' as datetime2(0)) AS ValidFrom, 
cast('9999-12-31' as datetime2(0)) AS ValidTo, 
1 AS IsCurrent
FROM ICONI.vBIRestart_Meeting M;
GO

