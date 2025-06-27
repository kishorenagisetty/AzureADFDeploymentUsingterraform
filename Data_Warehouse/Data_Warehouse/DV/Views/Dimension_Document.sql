CREATE VIEW [DV].[Dimension_Document] 
AS SELECT
DocumentHash
,DocumentID
,DocumentName
,DocumentStatus
,DocumentNotes
FROM (
		SELECT
		DocumentHash
		,row_number() OVER (PARTITION BY DocumentHash ORDER BY DocumentHash) rn
		,DocumentID
		,DocumentName
		,DocumentStatus
		,DocumentNotes
		FROM DV.Base_Document
		) src
WHERE (rn = 1);
GO
