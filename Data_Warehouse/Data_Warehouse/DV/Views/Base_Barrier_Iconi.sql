CREATE VIEW [DV].[Base_Barrier_Iconi]
AS SELECT
CONVERT(CHAR(66),Bi.BarriersHash ,1)			AS 'BarriersHash',
Bi.BarriersKey,
Bi.RecordSource,
'0'												AS BarrierCode,
CAST(BarrierName AS NVARCHAR(MAX))				AS BarrierName,
CAST(BarrierStatus AS NVARCHAR(MAX))			AS BarrierStatus,
CAST('Unknown' AS NVARCHAR(MAX))				AS BarrierCategory,
'0'												AS BarrierIsDisengagement,
BarrierValue									AS BarrierScore,
CAST(B_Aci.ValidFrom AS DATE) AS ValidFrom,
CAST(B_Aci.ValidTo AS DATE) AS ValidTo,
IsCurrent

FROM DV.HUB_Barriers Bi
INNER JOIN DV.SAT_Barriers_Iconi_Core B_ACi ON B_ACi.BarriersHash = Bi.BarriersHash
WHERE 
Bi.RecordSource = 'ICONI.Barrier';
GO

