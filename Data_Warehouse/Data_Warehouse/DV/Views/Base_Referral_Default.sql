CREATE VIEW [DV].[Base_Referral_Default]
AS SELECT
CONVERT(CHAR(66),CAST(0x0 AS BINARY(32)) ,1) AS ReferralHash,
CAST('Unknown' AS VARCHAR(50)) AS RecordSource,
CAST('Unknown' AS NVARCHAR(MAX)) AS PONumber,
CAST('Unknown' AS NVARCHAR(MAX)) AS PODescription,
CAST('Unknown' AS NVARCHAR(MAX)) AS ReferralType,
CAST('Unknown' AS NVARCHAR(MAX)) AS ReferralSourceOther,
CAST('Unknown' AS NVARCHAR(MAX)) AS Disability,
CAST('Unknown' AS NVARCHAR(MAX)) AS FastTrack,
CAST('Unknown' AS NVARCHAR(MAX)) AS Incident,
CAST('Unknown' AS NVARCHAR(MAX)) AS WelshSpoken,
CAST('Unknown' AS NVARCHAR(MAX)) AS WelshWritten,
CAST('Unknown' AS NVARCHAR(MAX)) AS Occupation,
CAST('Unknown' AS NVARCHAR(MAX)) AS IsApprentice;
GO

