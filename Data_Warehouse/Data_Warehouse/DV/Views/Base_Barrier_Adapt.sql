CREATE VIEW [DV].[Base_Barrier_Adapt]
AS SELECT
CONVERT(CHAR(66),B.BarriersHash ,1)             AS 'BarriersHash',
B_AC.BarriersKey,
B_AC.RecordSource,						            
CAST(R_BN.Code AS NVARCHAR(MAX))               AS BarrierCode,
CASE WHEN R_BN.[Description] IS NULL THEN 'Unknown' ELSE R_BN.[Description] END AS BarrierName,
CAST('Unknown' AS NVARCHAR(MAX))				AS BarrierType,
CAST('Unknown' AS NVARCHAR(MAX))                AS BarrierCategory,
CASE WHEN R_BN.[Description] LIKE '%Disengage%' THEN 1 ELSE 0 END AS BarrierIsDisengagement,
0  							                    AS BarrierScore,

-- 3 defaulted columns tem added to match number of columns for union
B_AC.ValidFrom     						        AS BarrierStartDate,
B_AC.ValidTo             						AS BarrierEndDate,
B_AC.IsCurrent									AS IsCurrent

FROM DV.HUB_Barriers B
INNER JOIN DV.SAT_Barriers_Adapt_Core B_AC ON B_AC.BarriersHash = B.BarriersHash AND B_AC.IsCurrent = 1
LEFT JOIN DV.Dimension_References R_BN ON R_BN.Code = B_AC.BarrierName AND R_BN.ReferenceSource = 'ADAPT.MD_MULTI_NAMES' AND R_BN.Category = 'Code'
WHERE 
B.RecordSource = 'ADAPT.PROP_BARRIER_GEN';
GO

