CREATE VIEW [DV].[Dimension_ForecastType]
AS SELECT 

CONVERT(CHAR(66),ISNULL(satft.ForecastTypeHash,CAST(0x0 AS BINARY(32))),1) AS ForecastTypeHash,
satft.ForecastTypeKey, 
satft.Type, 
satft.Longname
FROM  [DV].[HUB_ForecastType] hubft
left join [DV].[SAT_ForecastType_Meta_Core] satft on (satft.ForecastTypeHash = hubft.ForecastTypeHash);
GO

