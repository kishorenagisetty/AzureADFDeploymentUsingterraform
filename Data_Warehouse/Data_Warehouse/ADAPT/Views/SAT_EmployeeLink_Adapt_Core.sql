CREATE VIEW [ADAPT].[SAT_EmployeeLink_Adapt_Core]
AS (
Select
CONCAT_WS('|','ADAPT', CAST(E.REFERENCE AS INT))	AS CaseKey,
CONCAT_WS('|','ADAPT', CAST(E.EMPLOYEE AS INT))		AS EmployeeKey,
'ADAPT.PROP_X_WP_EMPL'								AS RecordSource,
EE.REFERENCE										AS REFERENCE,
E.PRIMARY_YN										AS PRIMARY_YN,
E.ValidFrom											AS ValidFrom,
E.ValidTo											AS ValidTo,
E.IsCurrent											AS IsCurrent

FROM
	ADAPT.PROP_X_WP_EMPL		AS E	
	LEFT JOIN 
	(
		select 
			REFERENCE					AS REFERENCE,
			MAX(BISUNIQUEID)			AS BISUNIQUEID
		from 
			ADAPT.PROP_X_WP_EMPL		AS EE
		group by
			 REFERENCE
	) AS EE
	ON E.REFERENCE = EE.REFERENCE
	);
