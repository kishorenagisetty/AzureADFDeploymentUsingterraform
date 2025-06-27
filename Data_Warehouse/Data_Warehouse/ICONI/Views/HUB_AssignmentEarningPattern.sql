CREATE VIEW [ICONI].[HUB_AssignmentEarningPattern]
AS SELECT distinct
		CONCAT_WS('|','ICONI' ,CONVERT(VARCHAR,ValidFrom,112), CAST(outcome_earnings_id AS INT)) AS AssignmentEarningPatternKey,
		'ICONI.Outcome_Earnings' AS RecordSource,
		E.ValidFrom, 
		E.ValidTo, 
		E.IsCurrent
	FROM 
		[ICONI].[vBICommon_Outcome_Earnings] AS E;