CREATE VIEW [dwh].[dim_ForecastsCohort] AS select		distinct
			convert(char(66),isnull(fcp.ProgrammeHash,cast(0x0 as binary(32))),1)	as ProgrammeHash
			,fco.RecordSource						as RecordSource
			,fmc.metricName							as MetricName
			,ftt.Type								as ForecastType
			,smc.sourceTypeName						as SourceTypeName
			,fnc.ForecastNameKey					as ForecastNameKey
			,fcm.ContractType						as ContractType
			,fcm.Initial							as Initial
			,fcm.DDA								as DDA
			,fcm.Conv								as Conv
			,fcm.CumulConv							as CumulConv
			,case when fcm.ValidFrom = (select min(ValidFrom) from DV.HUB_ForecastsCohort)
			 then cast('19000101' as datetime)
			 else fcm.ValidFrom	 end				as ValidFrom
			,fcm.ValidTo							as ValidTo
			,fcm.CohortMonthNumber					as CohortMonthNumber
from		DV.HUB_ForecastsCohort					fco
left join	DV.LINK_ForecastsCohort_Programme		fcp on fcp.ForecastsCohortHash	= fco.ForecastsCohortHash
left join	DV.SAT_ForecastsCohort_Meta_Core		fcm on fcm.ForecastsCohortHash	= fco.ForecastsCohortHash
left join	DV.LINK_ForecastsCohort_Metric			fme on fme.ForecastsCohortHash	= fco.ForecastsCohortHash
left join	DV.SAT_Metric_Meta_Core					fmc on fmc.MetricHash			= fme.MetricHash
left join	DV.LINK_ForecastsCohort_ForecastType	fft on fft.ForecastsCohortHash	= fco.ForecastsCohortHash
left join	DV.SAT_ForecastType_Meta_Core			ftt on ftt.ForecastTypeHash		= fft.ForecastTypeHash
left join	DV.LINK_ForecastsCohort_SourceType		fcs ON fcs.ForecastsCohortHash	= fco.ForecastsCohortHash
left join	DV.SAT_SourceType_Meta_Core				smc ON smc.SourceTypeHash		= fcs.SourceTypeHash
left join	DV.LINK_ForecastsCohort_ForecastName	ffn on ffn.ForecastsCohortHash	= fco.ForecastsCohortHash
left join	DV.SAT_ForecastName_Meta_Core			fnc on fnc.ForecastNameHash		= ffn.ForecastNameHash
where		fcm.IsCurrent = 1;