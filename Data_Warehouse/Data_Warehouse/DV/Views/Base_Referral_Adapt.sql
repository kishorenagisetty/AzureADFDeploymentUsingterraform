CREATE VIEW [DV].[Base_Referral_Adapt]
AS SELECT
	CONVERT(CHAR(66),R.ReferralHash ,1) AS ReferralHash,
	R.RecordSource,
	R_AC.PONumber,
	R_AC.PODescription,
	R_RT.Description AS ReferralType,
	CAST(NULL AS NVARCHAR(MAX)) AS ReferralSourceOther,
	R_D.Description AS Disability,
	R_AC.FastTrack,
	R_I.Description AS Incident,
	R_WS.Description AS WelshSpoken,
	R_WW.Description AS WelshWritten,
	CAST(NULL AS NVARCHAR(MAX)) AS Occupation,
	CAST(NULL AS NVARCHAR(MAX)) AS IsApprentice
FROM
DV.HUB_Referral R
INNER JOIN DV.SAT_Referral_Adapt_Core R_AC ON R_AC.ReferralHash = R.ReferralHash and R_AC.IsCurrent = 1
LEFT JOIN DV.Dimension_References R_RT ON R_RT.Code = R_AC.ReferralType AND R_RT.ReferenceSource = 'ADAPT.MD_MULTI_NAMES' AND R_RT.Category = 'Code'
LEFT JOIN DV.Dimension_References R_D ON R_D.Code = R_AC.Disability AND R_D.ReferenceSource = 'ADAPT.MD_MULTI_NAMES' AND R_D.Category = 'Code'
LEFT JOIN DV.Dimension_References R_I ON R_I.Code = R_AC.Incident AND R_I.ReferenceSource = 'ADAPT.MD_MULTI_NAMES' AND R_I.Category = 'Code'
LEFT JOIN DV.Dimension_References R_WS ON R_WS.Code = R_AC.WelshSpoken AND R_WS.ReferenceSource = 'ADAPT.MD_MULTI_NAMES' AND R_WS.Category = 'Code'
LEFT JOIN DV.Dimension_References R_WW ON R_WW.Code = R_AC.WelshWritten AND R_WW.ReferenceSource = 'ADAPT.MD_MULTI_NAMES' AND R_WW.Category = 'Code'
WHERE R.RecordSource = 'ADAPT.PROP_WP_GEN';
GO

