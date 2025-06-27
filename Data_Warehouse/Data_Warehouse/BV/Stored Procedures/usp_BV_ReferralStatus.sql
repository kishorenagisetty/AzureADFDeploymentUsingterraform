CREATE PROC [BV].[usp_BV_ReferralStatus] AS 
BEGIN

IF OBJECT_ID('BV.LINK_Referral_ReferralStatus') IS NOT NULL
BEGIN
	DROP TABLE BV.LINK_Referral_ReferralStatus
END

--Distribute the table by the HASH of ReferralHash.
--In almost all cases this will be joined onto the Referral first so that should
--help performance.
CREATE TABLE BV.LINK_Referral_ReferralStatus 
WITH (HEAP, DISTRIBUTION = HASH(ReferralHash))
AS
SELECT
	--Generate the standard columns included on a LINK table.
	CAST(
		HASHBYTES('SHA2_256',
			CONCAT(
				ISNULL(CAST(ReferralHash AS NVARCHAR(100)),''),
				ISNULL(CAST(ReferralStatusHash AS NVARCHAR(100)),'')
			)
		)
	AS BINARY(32)) AS Referral_ReferralStatusHash,
	R.ReferralHash,
	R.ReferralStatusHash,
	'BV.usp_BV_ReferralStatus' AS RecordSource,
	GETUTCDATE() AS ValidFrom
	FROM (
		SELECT R.ReferralHash, HASHBYTES('SHA2_256',R.ReferralStatus) ReferralStatusHash,
		ReferralStatus
		--More than one rule can hit. This ensures only one status per Referral and it's the one with the highest RuleRank
		,ROW_NUMBER() OVER (PARTITION BY R.ReferralHash ORDER BY R.RuleRank DESC) AS ReferralStatusRank
		FROM (
			SELECT 
				HR.ReferralHash,
				R.ReferralStatus,
				R.RuleRankHits,
				R.RuleRank,
				--Some rules stipulate one of several documents and can hit lots of times. We're just interested
				--In the number of unique RuleHits per RuleRank. This calculates it.
				DENSE_RANK() OVER (PARTITION BY HR.ReferralHash, R.RuleRank ORDER BY R.RuleID)
					+ DENSE_RANK() OVER (PARTITION BY HR.ReferralHash, R.RuleRank ORDER BY R.RuleID DESC)
					- 1 AS RuleHits
				--Can't do COUNT DISTINCT with window functions - found the above on stack overflow. Seems reasonable.
				--COUNT(DISTINCT R.RuleID) OVER (PARTITION BY HR.ReferralHash, RuleRank) AS RuleRankHits
			FROM DV.HUB_Referral HR
			--Start with Referral
			LEFT JOIN DV.LINK_Case_Referral LCR ON LCR.ReferralHash = HR.ReferralHash
			LEFT JOIN DV.LINK_Referral_ReferralDocument LRD ON LRD.ReferralHash = HR.ReferralHash	
			LEFT JOIN DV.LINK_Referral_Programme LRP ON LRP.ReferralHash = HR.ReferralHash
			--Get the link tables needed
			LEFT JOIN DV.SAT_ReferralDocument_Adapt_Core SRD ON SRD.ReferralDocumentHash = LRD.ReferralDocumentHash
			LEFT JOIN DV.SAT_Programme_Adapt_Core SP ON SP.ProgrammeHash = LRP.ProgrammeHash
			LEFT JOIN DV.SAT_Case_Adapt_Core SC ON SC.CaseHash = LCR.CaseHash
			LEFT JOIN DV.SAT_Case_Adapt_Dates SCD ON SCD.CaseHash = LCR.CaseHash
			--Then the satellites needed
			LEFT JOIN DV.Dimension_References R_S ON R_S.Code = SRD.DocumentStatus AND R_S.Category = 'CODE' and R_S.ReferenceSource = 'ADAPT.MD_MULTI_NAMES'
			LEFT JOIN DV.Dimension_References R_LR ON R_LR.Code = SC.LeaveReason AND R_LR.Category = 'CODE' and R_LR.ReferenceSource = 'ADAPT.MD_MULTI_NAMES'
			--Some attributes are contained within MD_MULTI_NAMES so look them up here
			
			--ReferralStatusRules is an external table within the metadata folder of the PSA
			--SELECT * FROM DV.ReferralStatusRules
			--We do a fuzzy join on the criteria contained within that table.
			INNER JOIN DV.ReferralStatusRules R ON 
				--Does the rule filter by programme name, if not the rule matches
				ISNULL(SP.ProgrammeName,'') LIKE ISNULL(REPLACE(R.ProgrammeName,' ','%'),'%') AND 
				--Does the rule require a document if so look for it otherwise the referral matches
				ISNULL(SRD.DocumentName,'') LIKE ISNULL(REPLACE(R.DocumentName, ' ', '%'),'%') AND 
				--Check the document status in conjunction with Leave Reson
				--There is a NotLeaveReson too which excludes too.
				ISNULL(R_S.Description ,'') LIKE ISNULL(REPLACE(R.DocumentStatus,' ','%'),'%') AND
					(ISNULL(R_LR.Description,'') LIKE ISNULL(REPLACE(R.LeaveReason,' ', '%'),'%') 
					OR (SC.LeaveReason IS NULL AND R.LeaveReason = 'NULL')) AND
				ISNULL(R_LR.Description,'') NOT LIKE ISNULL(R.NotLeaveReason, 'No Filter') AND
				--Some rules check for LeaveDate and StartDate here.
				CASE WHEN SCD.LeaveDate IS NULL THEN 'No' ELSE 'Yes' END LIKE ISNULL(R.LeaveDate,'%') AND
				CASE WHEN SCD.StartDate IS NULL THEN 'No' ELSE 'Yes' END LIKE ISNULL(R.StartDate,'%')
				) R
				WHERE R.RuleRankHits = R.RuleHits
			) R 
	WHERE R.ReferralStatusRank = 1

END