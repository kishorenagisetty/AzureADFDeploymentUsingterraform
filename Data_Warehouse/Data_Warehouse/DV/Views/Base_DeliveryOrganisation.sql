CREATE VIEW [DV].[Base_DeliveryOrganisation]
AS SELECT * FROM [DV].[Base_DeliveryOrganisation_Default] 
UNION ALL
SELECT * FROM [DV].[Base_DeliveryOrganisation_Iconi];
GO

