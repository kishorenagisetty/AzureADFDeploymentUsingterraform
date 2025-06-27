CREATE VIEW [DV].[Base_ReferralStatus]
AS SELECT
	CONVERT(CHAR(66),CAST(0x0 AS BINARY(32)),1) AS ReferralStatusHash,	
	CAST('Unknown' AS VARCHAR(100)) AS ReferralStatus
UNION ALL
SELECT 
	DISTINCT 

	CONVERT(CHAR(66),ISNULL(HASHBYTES('SHA2_256',ReferralStatus), 0x0),1) AS ReferralStatusHash,	
	CAST(ReferralStatus AS VARCHAR(100)) AS ReferralStatus
FROM DV.ReferralStatusRules R;