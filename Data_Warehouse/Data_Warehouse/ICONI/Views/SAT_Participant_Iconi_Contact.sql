CREATE VIEW [ICONI].[SAT_Participant_Iconi_Contact] AS SELECT
CONCAT_WS('|','ICONI',P.individual_id) AS ParticipantKey,
P.ind_telephone AS TelephoneHome,
P.ind_mobile AS TelephoneMobile,
P.ind_email AS Email,
P.ind_sms_opt_out AS SMSOptOut,
P.ind_email_opt_out AS EmailOptOut,
P.ind_leave_message AS LeaveMessage,
P.ind_preferred_contact AS PreferredCommunicationMethod,
P.ValidFrom AS ValidFrom,
P.ValidTo AS ValidTo,
P.IsCurrent AS IsCurrent
FROM ICONI.vBICommon_Individual as P;