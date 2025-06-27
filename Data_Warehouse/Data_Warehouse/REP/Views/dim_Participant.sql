CREATE VIEW [REP].[dim_Participant]
AS
-- ===============================================================
-- Author:	Sagar Kadiyala
-- Create date: 31/01/2024
-- Ticket Ref: #30330
-- Name: [REP].[dim_Participant] 
-- Description: Dimension Table
-- Revisions:
-- 30330 - SK - 01/02/2024 - Created a Dimension View for Participants / Candidates
-- ===============================================================
SELECT CONVERT(char(66), hp.ParticipantHash, 1)                       AS ParticipantHash
     , REPLACE(CAST(spc.ParticipantKey AS VARCHAR(25)), 'ICONI|', '') AS ParticipantKey
     , spc.Title                                                      AS Title
     , spc.FirstName                                                  AS FirstName
     , spc.LastName                                                   AS LastName
     , spc.FirstName + ' ' + spc.LastName                             AS FullName
     , spc.NationalInsuranceNo                                        AS NationalInsuranceNo
	 , spic.TelephoneMobile											  AS TelephoneMobile
	 , spic.Email													  AS Email
FROM DV.HUB_Participant                hp
    JOIN DV.SAT_Participant_Iconi_Core spc
        ON hp.ParticipantHash = spc.ParticipantHash
	JOIN [DV].[SAT_Participant_Iconi_Contact] spic
		ON hp.ParticipantHash = spic.ParticipantHash
WHERE spc.IsCurrent = 1
      AND hp.recordSource = 'ICONI.Participant';
Go

