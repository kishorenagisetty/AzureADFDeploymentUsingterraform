CREATE VIEW [ADAPT].[HUB_AssignmentEarningPattern] AS SELECT 
		CONCAT_WS('|','ADAPT' ,CAST(BISUNIQUEID AS INT),CAST(E.REFERENCE AS INT)) AS AssignmentEarningPatternKey,
		'ADAPT.PROP_RTE_HRS_HIST' AS RecordSource,
		E.ValidFrom, 
		E.ValidTo, 
		E.IsCurrent
	FROM 
		ADAPT.PROP_RTE_HRS_HIST AS E;
GO