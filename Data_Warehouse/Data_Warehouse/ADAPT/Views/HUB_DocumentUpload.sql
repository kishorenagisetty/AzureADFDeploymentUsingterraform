-- Author: 
-- Create date: DD/MM/YYY
-- Ticket Reference:  <Dev Ops Ticket Reference>
-- Description: <Description regarding object>
-- Revisions:
-- 13/10/2023 - <CH> - remove getdate

CREATE VIEW [ADAPT].[HUB_DocumentUpload]
AS SELECT CONCAT_WS('|', 'ADAPT', CAST(D.DOC_ID AS INT)) AS DocumentUploadKey
	,'ADAPT.DOCUMENTS' AS RecordSource
	,ValidFrom
	,ValidTo
	,IsCurrent
FROM ADAPT.DOCUMENTS D
WHERE D.IsCurrent = 1;
GO