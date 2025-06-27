CREATE VIEW [REP].[dim_Program] 
-- ===============================================================
-- Author:	Sagar Kadiyala
-- Create date: 31/01/2024
-- Ticket Ref: #30330
-- Name: [REP].[dim_Program]  
-- Description: Dimension Table
-- Revisions:
-- 30330 - SK - 31/01/2024 - Created a Dimension View for delivery Sites
-- ===============================================================
AS
SELECT CONVERT(char(66), hp.ProgrammeHash, 1) AS ProgrammeHash
     , hp.RecordSource                        AS RecordSource
     , hp.ProgrammeKey                        AS ProgrammeKey
     , sp.ProgrammeName                       AS ProgrammeName
FROM [DV].[HUB_Programme]                hp
    JOIN [DV].[SAT_Programme_Iconi_Core] sp
        ON hp.programmeHash = sp.programmeHash
WHERE sp.IsCurrent = 1
      AND sp.ProgrammeName = 'Refugee';
Go
