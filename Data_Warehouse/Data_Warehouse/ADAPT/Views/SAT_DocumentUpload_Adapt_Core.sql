-- Author: 
-- Create date: DD/MM/YYY
-- Ticket Reference:  <Dev Ops Ticket Reference>
-- Description: <Description regarding object>
-- Revisions:
-- 13/10/2023 - <CH> - remove getdate

CREATE VIEW [ADAPT].[SAT_DocumentUpload_Adapt_Core]
AS SELECT CONCAT_WS('|', 'ADAPT', CAST(D.DOC_ID AS INT)) AS DocumentKey
	  ,CONFIG_NAME					AS DocumentCategory
      ,DOC_NAME						AS DocumentName
      ,DOC_DESCRIPTION				AS DocumentDescription
      ,CREATED_DATE					AS CreatedDate
      ,UPDATED_DATE					AS UploadedDate
      ,MODIFY_DATE					AS ModifiedDate
      ,D.ValidFrom
      ,D.ValidTo
      ,D.IsCurrent
FROM ADAPT.DOCUMENTS D
INNER JOIN ADAPT.DOCUMENT_CATEGORIES DC
ON D.DOC_CATEGORY = DC.CATEGORY_ID;
GO