CREATE VIEW [ADAPT].[SAT_AssignmentEarningPattern_Adapt_Core] AS (


SELECT
	CONCAT_WS('|','ADAPT' ,CAST(BISUNIQUEID AS INT), CAST(RTE.REFERENCE AS INT))				AS AssignmentEarningPatternKey,
	'ADAPT.PROP_RTE_HRS_HIST'																	AS RecordSource,
	RTE.EFFECT_TO																				AS EffectTo,	
	RTE.REFERENCE																				AS Reference,	
	RTE.MON																						AS Monday,	
	RTE.TUE																						AS Tuesday,	
	RTE.WED																						AS Wednesday,
	RTE.THU																						AS Thursday,
	RTE.FRI																						AS Friday,
	RTE.SAT																						AS Saturday,
	RTE.SUN																						AS Sunday,
	RTE.WEEKLY_HRS																				AS WeeklyHours,	
	RTE.EFFECT_FROM																				AS EffectFrom,	
	RTE.HOURLY_RATE																				AS HourlyRate,	
	RTE.STATUS																					AS [Status],	
	RTE.DATE_CHANGED																			AS DateChanged,
	RTE.ValidFrom			  																	AS ValidFrom,	
	RTE.ValidTo				  																	AS ValidTo,	
	RTE.IsCurrent			  																	AS IsCurrent


FROM
	ADAPT.PROP_RTE_HRS_HIST					AS RTE


);
GO
