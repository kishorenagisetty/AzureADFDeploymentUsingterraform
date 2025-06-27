CREATE VIEW [ADAPT].[SAT_Correspondence_Adapt_Core] AS (
SELECT
CONCAT_WS('|','ADAPT',CAST([BISUNIQUEID] AS INT)) AS CorrespondenceKey,
CONCAT_WS('|','ADAPT',CAST(REFERENCE AS BIGINT)) AS CorrespondenceReferenceKey,
'ADAPT.PROP_WP_COM'						AS RecordSource,
OUTCOME AS 'CorrespondenceOutcome',
METHOD AS 'CorrespondenceMethod',
COMTYPE AS 'CorrespondenceType',
COM_DATE AS 'CorrespondenceDate',
CONT_BY AS 'CorrespondenceContactBy',
NOTES AS 'CorrespondenceNotes',
[ValidFrom],
[ValidTo],
IsCurrent
FROM ADAPT.PROP_WP_COM
);
GO