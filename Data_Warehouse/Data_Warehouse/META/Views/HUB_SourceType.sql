CREATE VIEW [META].[HUB_SourceType]
AS (
SELECT 
CONCAT_WS('|','META',[sourceType_ID])				  AS SourceTypeKey,
'ELT.SourceType'									  AS RecordSource,
CAST('2022-04-01' AS DATE)		  				      AS ValidFrom,
CAST('9999-12-31' AS DATE)							  AS ValidTo,
'1'													  AS IsCurrent
FROM 
ELT.SourceType
);
GO
