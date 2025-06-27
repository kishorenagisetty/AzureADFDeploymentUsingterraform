CREATE VIEW [DV].[Dimension_ReferralStatus]
AS SELECT
 [ReferralStatusHash]
,[ReferralStatus]

FROM (
	SELECT
		 [ReferralStatusHash]
		,row_number() OVER (PARTITION BY [ReferralStatusHash] ORDER BY [ReferralStatusHash]) rn
		,[ReferralStatus]
		FROM [DV].[Base_ReferralStatus]
		) src
WHERE (rn = 1);