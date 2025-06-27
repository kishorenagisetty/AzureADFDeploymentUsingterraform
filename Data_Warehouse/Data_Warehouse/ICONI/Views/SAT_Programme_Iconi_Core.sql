CREATE VIEW [ICONI].[SAT_Programme_Iconi_Core] 
-- ===============================================================
-- Author:	Sagar Kadiyala
-- Create date: 23/01/2024
-- Ticket Ref: #30330
-- Name: [ICONI].[SAT_Programme_Iconi_Core] 
-- Description: Runs the Hub Case Data
-- Revisions:
-- 30330 - SK - 23/01/2024 - Amended view to bring in Refugee data via Union
-- ===============================================================
AS 
SELECT 
CONCAT_WS('|','ICONI','Restart') AS ProgrammeKey,
'Restart' AS ProgrammeName,
'Restart' AS ProgrammeGroup,
'Restart' AS ProgrammeCategory,
CAST('2021-12-08' AS DATE) AS ValidFrom,
CAST('9999-12-31' AS DATE) AS ValidTo,
CAST(1 AS BIT) AS IsCurrent
UNION
SELECT 
CONCAT_WS('|','ICONI','Refugee') AS ProgrammeKey,
'Refugee' AS ProgrammeName,
'Refugee' AS ProgrammeGroup,
'Refugee' AS ProgrammeCategory,
CAST('2023-12-01' AS DATE) AS ValidFrom,
CAST('9999-12-31' AS DATE) AS ValidTo,
CAST(1 AS BIT) AS IsCurrent
Go