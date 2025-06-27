CREATE VIEW [ICONI].[SAT_Participant_Iconi_Core] AS SELECT 
CONCAT_WS('|','ICONI',P.individual_id) AS ParticipantKey,
'IND' + CAST(P.individual_id AS VARCHAR) AS ParticipantID,
P.ind_dob AS DateOfBirth,
P.ind_natins AS NationalInsuranceNo,
P.ind_title AS Title,
P.ind_forename AS FirstName,
P.ind_surname AS LastName,
P.ind_safeguarding_concerns AS SafeguardingConcerns,
P.ValidFrom AS ValidFrom,
P.ValidTo AS ValidTo,
P.IsCurrent AS IsCurrent
FROM ICONI.vBICommon_Individual as P;
GO

