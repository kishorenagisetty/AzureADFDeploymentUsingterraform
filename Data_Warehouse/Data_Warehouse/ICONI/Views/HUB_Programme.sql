CREATE VIEW [ICONI].[HUB_Programme]
-- ===============================================================
-- Author:	Sagar Kadiyala
-- Create date: 23/01/2024
-- Ticket Ref: #30330
-- Name: [ICONI].[HUB_Programme]
-- Description: Runs the Hub Case Data
-- Revisions:
-- 30330 - SK - 23/01/2024 - Amended view to bring in Refugee data via Union
-- ===============================================================
AS
SELECT 
CONCAT_WS('|','ICONI','Restart') AS ProgrammeKey,
'ICONI.Programme_Static' AS RecordSource,
CAST('2021-12-08' AS DATE) AS ValidFrom,
CAST('9999-12-31' AS DATE) AS ValidTo,
CAST(1 AS BIT) AS IsCurrent
UNION
SELECT
CONCAT_WS('|','ICONI','Refugee') AS ProgrammeKey,
'ICONI.Programme_Static' AS RecordSource,
CAST('2023-12-01' AS DATE) AS ValidFrom,
CAST('9999-12-31' AS DATE) AS ValidTo,
CAST(1 AS BIT) AS IsCurrent;
Go

