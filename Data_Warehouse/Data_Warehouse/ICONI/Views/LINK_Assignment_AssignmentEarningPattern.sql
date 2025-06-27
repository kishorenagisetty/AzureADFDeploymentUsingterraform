CREATE VIEW [ICONI].[LINK_Assignment_AssignmentEarningPattern]
AS (
	SELECT 
		CONCAT_WS('|','ICONI', CAST(O.outcome_id AS INT))												AS AssignmentKey,
		CONCAT_WS('|','ICONI' ,CONVERT(VARCHAR,OE.ValidFrom,112), CAST(OE.outcome_earnings_id AS INT))	AS AssignmentEarningPatternKey,
		'ICONI.Outcome'																					AS RecordSource,
		OE.ValidFrom 																					AS ValidFrom,
		OE.ValidTo 																						AS ValidTo, 
		OE.IsCurrent																					AS IsCurrent
	FROM 
		ICONI.vBIRestart_Outcome AS O
		INNER JOIN 
		[ICONI].[vBICommon_Outcome_Earnings] as OE 
		ON O.outcome_id = out_earn_entity_id
		
);
