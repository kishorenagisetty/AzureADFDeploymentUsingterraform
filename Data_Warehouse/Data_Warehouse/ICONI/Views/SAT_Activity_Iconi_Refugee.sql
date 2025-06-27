CREATE VIEW [ICONI].[SAT_Activity_Iconi_Refugee]
AS 
-- ===============================================================
-- Author:	Shaz Rehman
-- Create date: 23/11/2023
-- Ticket Ref: #30197
-- Name: [ICONI].[SAT_Activity_Iconi_Refugee]
-- Description: Runs the SAT Activity Data for Refugee
-- Revisions:
-- ===============================================================
SELECT 
CONCAT_WS('|','ICONI',M.meeting_id) AS ActivityKey,
'MET' + CAST(M.meeting_id AS VARCHAR) AS ActivityID,
M.meet_date_time AS ActivityStartDate,
M.meet_booked_duration AS ActivityBookedDuration,
M.meet_type AS ActivityType,
M.meet_sub_type AS ActivityContactMethod,
M.meet_advisor_user_id AS ActivityOwningEmployee,
M.meet_external_advisor AS ActivityOtherEmployee,
M.meet_location AS ActivityLocation,
M.meet_status AS ActivityStatus,
M.meet_duration AS ActivityActualDuration,
M.meet_related_entity_type AS ActivityLevel,
M.meet_agency_id,
M.meet_site_id,
M.meet_engagement_id,
M.meet_organisation_id,
M.meet_organisation_contact_id,
M.meet_added_date,
M.meet_added_by_user_id,
M.meet_complete_date AS ActivityCompletedDate,
M.meet_complete_by_user_id AS ActivityCompletedBy,
M.meet_mandated AS ActivityIsMandatory,
M.meet_action_plan_complete AS ActivityIsActionPlanComplete,
M.meet_attendance_reason AS ActivityDidNotAttendReason,
M.meet_attendance_reason_other AS AttendanceReasonOther,
M.meet_rebooked AS ActivityIsRebooked,
M.meet_last_updated_date AS LastUpdatedDate,
M.ValidFrom, M.ValidTo, M.IsCurrent
FROM ICONI.vBIRefugee_Meeting M;
GO