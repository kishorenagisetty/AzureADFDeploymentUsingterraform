-- Author: 
-- Create date: DD/MM/YYY
-- Ticket Reference:  <Dev Ops Ticket Reference>
-- Description: <Description regarding object>
-- Revisions:
-- 13/10/2023 - <CH> - remove getdate

CREATE VIEW [ADAPT].[LINK_Case_DocumentUpload]
AS SELECT
CONCAT_WS('|','ADAPT',CAST(WP.REFERENCE AS INT)) AS CaseKey,
CONCAT_WS('|', 'ADAPT', CAST(D.DOC_ID AS INT)) AS DocumentUploadKey,
'ADAPT.DOCUMENTS' AS RecordSource,
D.ValidFrom, 
D.ValidTo, 
D.IsCurrent
FROM ADAPT.PROP_WP_GEN WP
INNER JOIN ADAPT.DOCUMENTS D ON D.OWNER_ID = WP.REFERENCE;
GO