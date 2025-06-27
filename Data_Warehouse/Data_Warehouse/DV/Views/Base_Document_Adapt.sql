CREATE VIEW [DV].[Base_Document_Adapt] 
AS SELECT 
CONVERT(CHAR(66),D.DocumentHash,1) AS DocumentHash,
CAST(D.DocumentKey AS VARCHAR) AS DocumentID,
D.DocumentName,
DS.Description		AS DocumentStatus,
D.Notes				AS DocumentNotes
FROM DV.SAT_Document_Adapt_Core D
LEFT JOIN DV.Dimension_References DS
ON DS.Code = D.[Status] AND DS.Category = 'CODE' AND DS.ReferenceSource = 'ADAPT.MD_MULTI_NAMES'
WHERE D.IsCurrent = 1;
GO