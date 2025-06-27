CREATE VIEW [ICONI].[SAT_Participant_Iconi_Equality] AS SELECT 
CONCAT_WS('|','ICONI',P.individual_id) AS ParticipantKey,
P.ind_gender AS Gender,
P.ind_religion AS Religion,
Case when isnull(P.ind_ethnic_origin_other, '') != '' and isnull(P.ind_ethnic_origin, '') != '' then 
		P.ind_ethnic_origin_other + '|' + P.ind_ethnic_origin 
	when isnull(P.ind_ethnic_origin_other, '') != '' and isnull(P.ind_ethnic_origin, '') != '' then 
		P.ind_ethnic_origin_other + '|' + P.ind_ethnic_origin 
	when isnull(P.ind_ethnic_origin_other, '') = '' and isnull(P.ind_ethnic_origin, '') != '' then 
		P.ind_ethnic_origin
	when isnull(P.ind_ethnic_origin_other, '') != '' and isnull(P.ind_ethnic_origin, '') = '' then
		P.ind_ethnic_origin_other
	end	AS Ethnicity,
P.ind_age_when_added AS AgeAtRecordCreation,
P.ind_eligibility_status AS EligibilityStatus,
P.ind_reasonable_adjustments AS ReasonableAdjustments,
P.ind_added_date AS ParticipantAddedDate,
P.ind_added_by_user_id AS ParticipantAddedBy,
P.ind_last_updated_date AS ParticipantUpdatedDate,
P.ValidFrom AS ValidFrom,
P.ValidTo AS ValidTo,
P.IsCurrent AS IsCurrent
FROM ICONI.vBICommon_Individual as P;