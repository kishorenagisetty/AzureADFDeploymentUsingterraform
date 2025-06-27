CREATE VIEW [ADAPT].[LINK_Assignment_AssignmentEarningPattern] AS (
	SELECT 
		CONCAT_WS('|','ADAPT', CAST(P.ASSIG_ID AS INT))											AS AssignmentKey,
		CONCAT_WS('|','ADAPT' ,CAST(E.BISUNIQUEID AS INT),CAST(E.REFERENCE AS INT))				AS AssignmentEarningPatternKey,
		'ADAPT.PROP_RTE_HRS_HIST'																AS RecordSource,
		E.ValidFrom 																			AS ValidFrom,
		E.ValidTo 																				AS ValidTo, 
		E.IsCurrent																				AS IsCurrent
	FROM 
		ADAPT.PROP_RTE_HRS_HIST AS E
		INNER JOIN 
		ADAPT.PROP_ASSIG_GEN AS P
		ON P.REFERENCE = E.REFERENCE AND P.IsCurrent = 1
	
);
GO