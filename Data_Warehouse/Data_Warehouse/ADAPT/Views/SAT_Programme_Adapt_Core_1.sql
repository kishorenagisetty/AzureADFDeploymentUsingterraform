CREATE VIEW [ADAPT].[SAT_Programme_Adapt_Core] AS SELECT 
TRIM(P.NAME) AS ProgrammeKey,
TRIM(P.NAME) AS ProgrammeNAME,
MIN(ValidFrom) ValidFrom, MAX(ValidTo) ValidTo, CAST(1 AS BIT) AS IsCurrent FROM ADAPT.PROP_WP_GEN P
WHERE NULLIF(NAME,'') IS NOT NULL and P.IsCurrent = 1
GROUP BY P.NAME;
