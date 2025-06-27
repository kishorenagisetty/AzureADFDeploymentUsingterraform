CREATE VIEW [DV].[Dimension_DocumentUpload]
AS SELECT
DocumentUploadHash
,DocumentUploadID
,DocumentName
,DocumentDescription
,DocumentCategory
FROM (
		SELECT
		DocumentUploadHash
		,row_number() OVER (PARTITION BY DocumentUploadHash ORDER BY DocumentUploadHash) rn
		,DocumentUploadID
		,DocumentName
		,DocumentDescription
		,DocumentCategory
		FROM DV.Base_DocumentUpload
		) src
WHERE (rn = 1);
GO