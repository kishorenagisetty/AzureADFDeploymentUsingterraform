CREATE VIEW [DV].[Fact_Forecasts]
AS SELECT 
	CONVERT(CHAR(66),ISNULL(fhub.[ForecastsHash],CAST(0x0 AS BINARY(32))),1) AS ForecastsHash,
	CONVERT(CHAR(66),ISNULL(fsat.[ForecastsKey],CAST(0x0 AS BINARY(32))),1) AS ForecastsKey,
	CONVERT(CHAR(66),ISNULL(fsat.[ContentHash],CAST(0x0 AS BINARY(32))),1) AS ContentHash,
	CONVERT(CHAR(66),ISNULL(msat.[MetricHash],CAST(0x0 AS BINARY(32))),1) AS MetricHash,
	CONVERT(CHAR(66),ISNULL(ftsat.[ForecastTypeHash],CAST(0x0 AS BINARY(32))),1) AS ForecastTypeHash,
	CONVERT(CHAR(66),ISNULL(stsat.[SourceTypeHash],CAST(0x0 AS BINARY(32))),1) AS SourceTypeHash,
	CONVERT(CHAR(66),ISNULL(plink.[ProgrammeHash],CAST(0x0 AS BINARY(32))),1) AS ProgrammeHash,
	CONVERT(CHAR(66),ISNULL(dlink.[DeliverySiteHash],CAST(0x0 AS BINARY(32))),1) AS DeliverySiteHash,
	CONVERT(CHAR(66),ISNULL(fnlink.[ForecastNameHash],CAST(0x0 AS BINARY(32))),1) AS ForecastNameHash,
	fsat.[ForecastValue],
	fhub.[RecordSource],
	fsat.[ValidFrom],
	fsat.[ValidTo],
	fsat.[IsCurrent]
FROM
[DV].[HUB_Forecasts] fhub
LEFT JOIN [DV].[SAT_Forecasts_Meta_Core] fsat ON fsat.ForecastsHash = fhub.[ForecastsHash]
LEFT JOIN [DV].[LINK_Forecasts_Metric] mlink ON fhub.[ForecastsHash] = mlink.[ForecastsHash]
LEFT JOIN [DV].[SAT_Metric_Meta_Core] msat ON msat.[MetricHash] = mlink.[MetricHash]
LEFT JOIN [DV].[LINK_Forecasts_ForecastType] ftlink ON fhub.[ForecastsHash] = ftlink.[ForecastsHash]
LEFT JOIN [DV].[SAT_ForecastType_Meta_Core] ftsat ON ftsat.[ForecastTypeHash] = ftlink.[ForecastTypeHash]
LEFT JOIN [DV].[LINK_Forecasts_SourceType] stlink ON fhub.[ForecastsHash] = stlink.[ForecastsHash]
LEFT JOIN [DV].[SAT_SourceType_Meta_Core] stsat ON stsat.[SourceTypeHash] = stlink.[SourceTypeHash]
LEFT JOIN [DV].[LINK_Forecasts_Programme] plink ON fhub.[ForecastsHash] = plink.[ForecastsHash]
LEFT JOIN [DV].[LINK_Forecasts_DeliverySite] dlink ON fhub.[ForecastsHash] = dlink.[ForecastsHash]
LEFT JOIN [DV].[LINK_Forecasts_ForecastName] fnlink ON fhub.[ForecastsHash] = fnlink.[ForecastsHash]
LEFT JOIN [DV].[SAT_ForecastName_Meta_Core] fnsat ON fnsat.[ForecastNameHash] = fnlink.[ForecastNameHash];
GO

