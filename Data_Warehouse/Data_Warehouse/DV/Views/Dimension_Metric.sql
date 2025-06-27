CREATE VIEW [DV].[Dimension_Metric]
AS SELECT 
CONVERT(CHAR(66),ISNULL(satm.MetricHash,CAST(0x0 AS BINARY(32))),1) AS MetricHash, 
satm.MetricKey, 
satm.metricName
FROM [DV].[HUB_Metric] hubm
left join [DV].[SAT_Metric_Meta_Core] satm on (satm.MetricHash = hubm.MetricHash);
GO

