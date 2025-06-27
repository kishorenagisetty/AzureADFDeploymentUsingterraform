-- Author: 
-- Create date: DD/MM/YYY
-- Ticket Reference:  <Dev Ops Ticket Reference>
-- Description: <Description regarding object>
-- Revisions:
-- 13/10/2023 - <CH> - remove getdate
CREATE VIEW [ADAPT].[SAT_Referral_Adapt_Core] AS WITH JCP AS  
(
SELECT
pcp.REFERENCE
,nullif(min(pcp.JCP_FORENAME + ' ' + pcp.JCP_SURNAME),'')     as ReferringWorkCoach
,nullif(min(pcp.ST_LOCATION),'')                              as ReferringJCP
FROM ADAPT.PROP_CAND_PRAP pcp
WHERE pcp.IsCurrent = 1
GROUP BY pcp.REFERENCE
)
SELECT
CONCAT_WS('|','ADAPT',CAST(CP.REFERENCE AS INT)) AS ReferralKey,
CP.PRAP_REF AS PONumber,
NULLIF(CP.PO_DESCRIPT,'') AS PODescription,
CP.REFERRAL_DT AS ReferralDate,
CAST(CP.REFERRAL_TYP AS BIGINT) AS ReferralType,
CAST(CP.DISABILITY AS BIGINT) AS Disability,
CP.FASTTRACK AS FastTrack,
CAST(CP.INCIDENT AS INT) AS Incident,
CAST(CP.WELSHSPOKEN AS INT) AS WelshSpoken,
CAST(CP.WELSHWRITTEN AS INT) AS WelshWritten,
JCP.ReferringWorkCoach,
JCP.ReferringJCP,
CP.ValidFrom,CP.ValidTo,CP.IsCurrent
FROM
ADAPT.PROP_CAND_PRAP CP
INNER JOIN JCP ON JCP.REFERENCE = CP.REFERENCE;
GO
