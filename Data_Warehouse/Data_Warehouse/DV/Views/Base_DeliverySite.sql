CREATE VIEW [DV].[Base_DeliverySite]
AS SELECT * FROM [DV].[Base_DeliverySite_Default]
UNION ALL
SELECT * FROM [DV].[Base_DeliverySite_Adapt]
UNION ALL
SELECT * FROM [DV].[Base_DeliverySite_Iconi];
GO

