CREATE VIEW [ICONI].[LINK_Referral_Participant] AS SELECT 
CONCAT_WS('|','ICONI', C.engagement_id) AS ReferralKey,
CONCAT_WS('|','ICONI', P.individual_id) AS ParticipantKey,
'ICONI.Individual' AS RecordSource,
P.ValidFrom, 
P.ValidTo, 
P.IsCurrent
FROM ICONI.vBICommon_Individual AS P
INNER JOIN ICONI.vBIRestart_Engagement AS C
ON P.individual_id = C.eng_tran_individual_id
AND P.IsCurrent = 1
AND C.IsCurrent = 1