CREATE VIEW [DV].[Base_Participant]
AS SELECT * FROM [DV].[Base_Participant_Default]
UNION ALL
SELECT * FROM [DV].[Base_Participant_Adapt]
UNION ALL
SELECT * FROM [DV].[Base_Participant_Iconi];
GO

