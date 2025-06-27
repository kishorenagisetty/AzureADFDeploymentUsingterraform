CREATE VIEW [META].[SAT_SourceType_Meta_Core]
AS (
SELECT 
CONCAT_WS('|','META',[sourceType_ID])	  AS SourceTypeKey
,sourceTypeName
,CAST('2022-04-01' AS DATE)				  AS ValidFrom
,'9999-12-31'						      AS ValidTo
,'1'									  AS IsCurrent
FROM 
ELT.SourceType
);
GO

