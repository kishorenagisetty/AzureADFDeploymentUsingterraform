CREATE VIEW [DV].[Base_DocumentUpload_Adapt]
AS SELECT 
CONVERT(CHAR(66),D.DocumentUploadHash,1) AS DocumentUploadHash,
CAST(D.DocumentUploadKey AS VARCHAR) AS DocumentUploadID,
D.DocumentName,
D.DocumentDescription,
D.DocumentCategory
FROM DV.SAT_DocumentUpload_Adapt_Core D
WHERE D.IsCurrent = 1;
GO