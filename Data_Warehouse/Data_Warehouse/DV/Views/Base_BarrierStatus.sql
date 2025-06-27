CREATE VIEW [DV].[Base_BarrierStatus]
AS SELECT CONVERT(CHAR(66),CAST(0x0 AS BINARY(32)),1) AS BarrierStatusHash
,'Unknown' AS RecordSource
,'0' AS BarrierCode
,'Unknown' AS BarrierStatusName
UNION ALL
SELECT
 CONVERT(CHAR(66), CAST(HASHBYTES('SHA2_256',CAST(CAST(R.Code AS INT) AS VARCHAR)) AS BINARY(32)),1) AS BarrierStatusHash,
 'ADAPT.PROP_BARRIER_GEN' AS RecordSource
 ,R.Code AS BarrierCode
 ,R.Description AS BarrierStatusName
FROM DV.Dimension_References R WHERE Code IN (
SELECT DISTINCT BarrierStatus FROM DV.SAT_Barriers_Adapt_Core B WHERE B.BarrierStatus IS NOT NULL AND Category = 'Code' AND ReferenceSource = 'ADAPT.MD_MULTI_NAMES'
);
