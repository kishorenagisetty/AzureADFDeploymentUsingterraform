CREATE VIEW [DV].[Dimension_Referral]
AS SELECT
 [ReferralHash]
,[RecordSource]
,[PONumber]
,[PODescription]
,[ReferralType]
,[ReferralSourceOther]
,[Disability]
,[FastTrack]
,[Incident]
,[WelshSpoken]
,[WelshWritten]
,[Occupation]
,[IsApprentice]

FROM ( SELECT
		 [ReferralHash]
		,row_number() OVER (PARTITION BY [ReferralHash] ORDER BY [ReferralHash]) rn
		,[RecordSource]
		,[PONumber]
		,[PODescription]
		,[ReferralType]
		,[ReferralSourceOther]
		,[Disability]
		,[FastTrack]
		,[Incident]
		,[WelshSpoken]
		,[WelshWritten]
		,[Occupation]
		,[IsApprentice]

		FROM [DV].[Base_Referral]
		) src
WHERE (rn = 1);