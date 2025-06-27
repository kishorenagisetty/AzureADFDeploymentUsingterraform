CREATE VIEW [ADAPT].[SAT_Document_Adapt_Core] AS SELECT CONCAT_WS('|', 'ADAPT', CAST(D.ID AS INT)) AS DocumentKey
	,CONCAT_WS('|', 'ADAPT', CAST(D.REFERENCE AS INT)) AS DocumentReferenceKey
      ,D.DOCNAME						AS DocumentName
	  ,DOC.DOCUMENT						AS Document
      ,CAST(D.RECEIVER AS INT)			AS Receiver
      ,D.RECEIVED_DT					AS ReceivedDate
      ,D.SENT_DT						AS SentDate
      ,D.RESENT_DT						AS ResentDate
      ,CAST(D.[STATUS] AS BIGINT)		AS [Status]
      ,CAST(D.COMPLETED_BY AS INT)		AS CompletedBy
      ,D.COMPLETED_DT					AS CompletedDate
      ,CAST(D.QUERIED_BY AS INT)		AS QueriedBy
      ,D.QUERIED_DT						AS QueriedDate
      ,D.NOTES							AS Notes
      ,CAST(D.SENDER AS INT)			AS Sender
      ,CAST(D.RESENDER AS INT)			AS Resender
      ,D.ValidFrom
      ,D.ValidTo
      ,D.IsCurrent
FROM ADAPT.PROP_DOCTRACK_GEN D
LEFT JOIN ADAPT.vw_Documents_PSA DOC	ON D.ID = DOC.DOC_ID    AND DOC.IsCurrent = 1
WHERE D.ID IS NOT NULL;
GO