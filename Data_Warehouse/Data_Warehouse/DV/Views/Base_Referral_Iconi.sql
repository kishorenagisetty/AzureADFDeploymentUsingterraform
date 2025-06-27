CREATE VIEW [DV].[Base_Referral_Iconi]
AS SELECT
	CONVERT(CHAR(66),R.ReferralHash ,1) AS ReferralHash,
	R.RecordSource,
	I_RC.PONumber,
	I_RC.PODescription,
	I_RC.ReferralType,
	I_RC.ReferralSourceOther,
	CASE WHEN I_RC.Disability = 'NOT_S' THEN NULL ELSE I_RC.Disability END AS Disability,
	CAST(NULL AS NVARCHAR(MAX)) AS FastTrack,
	CAST(NULL AS NVARCHAR(MAX)) AS Incident,
	CAST(NULL AS NVARCHAR(MAX)) AS WelshSpoken,
	CAST(NULL AS NVARCHAR(MAX)) AS WelshWritten,
	CAST(NULL AS NVARCHAR(MAX)) AS Occupation,
	CAST(NULL AS NVARCHAR(MAX)) AS IsApprentice
FROM
DV.HUB_Referral R
INNER JOIN DV.SAT_Referral_Iconi_Core I_RC ON I_RC.ReferralHash = R.ReferralHash and I_RC.IsCurrent = 1
WHERE R.RecordSource = 'ICONI.Engagement';
GO

