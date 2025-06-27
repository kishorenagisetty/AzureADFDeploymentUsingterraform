CREATE VIEW [ICONI].[SAT_ActivityType_Iconi_Refugee]
AS 
-- ===============================================================
-- Author:	Shaz Rehman
-- Create date: 23/11/2023
-- Ticket Ref: #30197
-- Name: [ICONI].[SAT_ActivityType_Iconi_Refugee]
-- Description: Runs the SAT Activity Type Data
-- Revisions:
-- ===============================================================
SELECT DISTINCT
CONCAT_WS('|','ICONI', M.meet_type) AS ActivityTypeKey,
M.meet_type AS ActivityType,
CAST('1900-01-02' AS DATETIME2(0)) AS ValidFrom, 
CAST('9999-12-31' AS DATETIME2(0)) AS ValidTo, 
1 AS IsCurrent
FROM ICONI.vBIRefugee_Meeting M;