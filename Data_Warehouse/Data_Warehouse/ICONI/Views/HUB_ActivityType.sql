CREATE VIEW [ICONI].[HUB_ActivityType]
AS 
-- ===============================================================
-- Author:	Shaz Rehman
-- Create date: 23/11/2023
-- Ticket Ref: #30197
-- Name: [ICONI].[HUB_ActivityType]
-- Description: Runs the Link Case Activity Type Data
-- Revisions:
-- 30197 - SR - 23/11/2023 - Amended view to bring in Refugee data via Union
-- ===============================================================
SELECT DISTINCT
CONCAT_WS('|','ICONI',AC.ActivityType) AS ActivityTypeKey,
'ICONI.ActivityType_Restart' AS RecordSource,
CAST('1900-01-02' AS DATETIME2(0)) AS ValidFrom, 
CAST('9999-12-31' AS DATETIME2(0)) AS ValidTo, 
1 AS IsCurrent
FROM ELT.ActivityCategories AC
INNER JOIN ICONI.vBIRestart_Meeting AS M
ON M.meet_type = AC.ActivityType
AND AC.Source = 'Iconi'
-- 30197 - SR - 23/11/2023
UNION
SELECT DISTINCT
CONCAT_WS('|','ICONI',AC.ActivityType) AS ActivityTypeKey,
'ICONI.ActivityType_Refugee' AS RecordSource,
CAST('1900-01-02' AS DATETIME2(0)) AS ValidFrom, 
CAST('9999-12-31' AS DATETIME2(0)) AS ValidTo, 
1 AS IsCurrent
FROM ELT.ActivityCategories AC
INNER JOIN ICONI.vBIRefugee_Meeting AS M
ON M.meet_type = AC.ActivityType
AND AC.Source = 'Iconi'
--
;