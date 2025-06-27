CREATE VIEW [DV].[Base_ActivityStatus_Default]
AS SELECT
CONVERT(CHAR(66),CAST(0x0 AS BINARY(32)),1) AS ActivityStatusHash,
CAST('ADAPT.PROP_ACTIVITY_GEN' AS NVARCHAR(MAX)) AS RecordSource,
CAST('Unknown' AS NVARCHAR(MAX)) AS ActivityStatus ,
'0' AS ActivityStatusCode
UNION ALL
SELECT
CONVERT(CHAR(66),CAST(0x0 AS BINARY(32)),1) AS ActivityStatusHash,
CAST('ICONI.Meeting' AS NVARCHAR(MAX)) AS RecordSource,
CAST('Unknown' AS NVARCHAR(MAX)) AS ActivityStatus ,
'0' AS ActivityStatusCode;
GO
