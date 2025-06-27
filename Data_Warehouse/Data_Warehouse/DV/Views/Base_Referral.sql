CREATE VIEW [DV].[Base_Referral]
AS SELECT * FROM [DV].[Base_Referral_Default]
UNION ALL
SELECT * FROM [DV].[Base_Referral_Adapt]
UNION ALL
SELECT * FROM [DV].[Base_Referral_Iconi];
GO

