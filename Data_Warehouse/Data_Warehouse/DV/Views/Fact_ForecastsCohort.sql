CREATE VIEW [DV].[Fact_ForecastsCohort]
AS SELECT 
	CONVERT(CHAR(66),ISNULL(fhub.[ForecastsCohortHash],CAST(0x0 AS BINARY(32))),1) AS ForecastsCohortHash,
	CONVERT(CHAR(66),ISNULL(fsat.[ForecastsCohortKey],CAST(0x0 AS BINARY(32))),1) AS ForecastsCohortKey,
	CONVERT(CHAR(66),ISNULL(fsat.[ContentHash],CAST(0x0 AS BINARY(32))),1) AS ContentHash,
	CONVERT(CHAR(66),ISNULL(msat.[MetricHash],CAST(0x0 AS BINARY(32))),1) AS MetricHash,
	CONVERT(CHAR(66),ISNULL(ftsat.[ForecastTypeHash],CAST(0x0 AS BINARY(32))),1) AS ForecastTypeHash,
	CONVERT(CHAR(66),ISNULL(stsat.[SourceTypeHash],CAST(0x0 AS BINARY(32))),1) AS SourceTypeHash,
	CONVERT(CHAR(66),ISNULL(plink.[ProgrammeHash],CAST(0x0 AS BINARY(32))),1) AS ProgrammeHash,
	CONVERT(CHAR(66),ISNULL(fnlink.[ForecastNameHash],CAST(0x0 AS BINARY(32))),1) AS ForecastNameHash,
	fsat.[ContractType],
	fsat.[Initial],
	fsat.[DDA],
	fsat.[Conv],
	fsat.[CumulConv],
	fsat.[ValidFrom],
	fsat.[ValidTo],
	fsat.[IsCurrent],
	[CohortMonthNumber],
	fhub.[RecordSource]
FROM
[DV].[HUB_ForecastsCohort] fhub
LEFT JOIN [DV].[SAT_ForecastsCohort_Meta_Core] fsat ON fsat.ForecastsCohortHash = fhub.[ForecastsCohortHash]
LEFT JOIN [DV].[LINK_ForecastsCohort_Metric] mlink ON fhub.[ForecastsCohortHash] = mlink.[ForecastsCohortHash]
LEFT JOIN [DV].[SAT_Metric_Meta_Core] msat ON msat.[MetricHash] = mlink.[MetricHash]
LEFT JOIN [DV].[LINK_ForecastsCohort_ForecastType] ftlink ON fhub.[ForecastsCohortHash] = ftlink.[ForecastsCohortHash]
LEFT JOIN [DV].[SAT_ForecastType_Meta_Core] ftsat ON ftsat.[ForecastTypeHash] = ftlink.[ForecastTypeHash]
LEFT JOIN [DV].[LINK_ForecastsCohort_SourceType] stlink ON fhub.[ForecastsCohortHash] = stlink.[ForecastsCohortHash]
LEFT JOIN [DV].[SAT_SourceType_Meta_Core] stsat ON stsat.[SourceTypeHash] = stlink.[SourceTypeHash]
LEFT JOIN [DV].[LINK_ForecastsCohort_Programme] plink ON fhub.[ForecastsCohortHash] = plink.[ForecastsCohortHash]
LEFT JOIN [DV].[LINK_ForecastsCohort_ForecastName] fnlink ON fhub.[ForecastsCohortHash] = fnlink.[ForecastsCohortHash]
LEFT JOIN [DV].[SAT_ForecastName_Meta_Core] fnsat ON fnsat.[ForecastNameHash] = fnlink.[ForecastNameHash];
GO