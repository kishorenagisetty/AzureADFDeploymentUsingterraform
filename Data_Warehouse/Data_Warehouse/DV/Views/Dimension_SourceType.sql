CREATE VIEW [DV].[Dimension_SourceType]
AS SELECT 
CONVERT(CHAR(66),ISNULL(satst.SourceTypeHash,CAST(0x0 AS BINARY(32))),1) AS SourceTypeHash, 
satst.SourceTypeKey, 
satst.SourceTypeName
FROM [DV].[HUB_SourceType] hubst
left join [DV].[SAT_SourceType_Meta_Core] satst on (satst.SourceTypeHash = hubst.SourceTypeHash);
GO

