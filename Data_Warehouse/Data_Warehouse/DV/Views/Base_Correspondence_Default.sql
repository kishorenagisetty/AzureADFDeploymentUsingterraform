CREATE VIEW DV.Base_Correspondence_Default AS
SELECT
CONVERT(CHAR(66),CAST(0x0 AS BINARY(32)),1) AS CorrespondenceHash
,CAST('Unknown' AS NVARCHAR(MAX)) AS RecordSource
,CAST('Unknown' AS NVARCHAR(MAX)) AS CorrespondenceOutcome
,CAST('Unknown' AS NVARCHAR(MAX)) AS CorrespondenceMethod
,CAST('Unknown' AS NVARCHAR(MAX)) AS CorrespondenceType
,CAST('Unknown' AS NVARCHAR(MAX)) AS CorrespondenceNotes;
GO