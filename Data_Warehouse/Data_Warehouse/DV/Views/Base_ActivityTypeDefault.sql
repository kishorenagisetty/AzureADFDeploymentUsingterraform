CREATE VIEW [DV].[Base_ActivityType_Default] AS SELECT
CONVERT(CHAR(66),CAST(0x0 AS BINARY(32)),1) AS ActivityTypeHash,
CAST('Unknown' AS NVARCHAR(MAX)) AS RecordSource,
CAST('Unknown' AS NVARCHAR(MAX)) AS ActivityType,
'0' AS ActivityTypeCode,
CAST('Unknown' AS NVARCHAR(MAX)) AS ActivityRole,
CAST('Unknown' AS NVARCHAR(MAX)) AS ActivityCategory;
GO