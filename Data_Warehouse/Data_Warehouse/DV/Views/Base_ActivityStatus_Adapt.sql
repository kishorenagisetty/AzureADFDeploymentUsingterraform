CREATE VIEW [DV].[Base_ActivityStatus_Adapt]
AS SELECT
CONVERT(CHAR(66), CAST(HASHBYTES('SHA2_256',CAST(CAST(R.Code AS BIGINT) AS VARCHAR)) AS BINARY(32)),1) AS ActivityStatusHash
,CAST('ADAPT.PROP_ACTIVITY_GEN' AS NVARCHAR(MAX)) AS RecordSource
,R.Description AS ActivityStatus
,CAST(R.Code AS VARCHAR) AS ActivityStatusCode
FROM
DV.Dimension_References R WHERE Code IN (
SELECT DISTINCT ActivityStatus FROM DV.SAT_Activity_Adapt_Core AC WHERE AC.ActivityStatus IS NOT NULL AND Category = 'Code' AND ReferenceSource = 'ADAPT.MD_MULTI_NAMES'
);
GO

