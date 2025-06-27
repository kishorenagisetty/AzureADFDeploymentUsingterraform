CREATE PROC [ELT].[sp_UpdateDQAlertStatusEmailDateTime] AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON

    -- Insert statements for procedure here
UPDATE dq_as
SET 
	dq_as.EmailNotificationonFailureSentDateTime = ctl_el_fail.EmailSentOn
,	dq_as.EmailNotificationonSuccessSentDateTime = ctl_el_comp.EmailSentOn
FROM [ELT].[DQ_Alert_Status] dq_as
	LEFT JOIN [ELT].[CTL_Email_Log] ctl_el_comp
		ON dq_as.DqAlertStatusID = ctl_el_comp.DqAlertStatusID
		 AND ctl_el_comp.[Type] = 'Complete'
	LEFT JOIN [ELT].[CTL_Email_Log] ctl_el_fail
		ON dq_as.DqAlertStatusID = ctl_el_fail.DqAlertStatusID
		AND ctl_el_fail.[Type] = 'Failure'
WHERE
	(ctl_el_fail.dqalertstatusid IS NOT NULL AND dq_as.EmailNotificationonFailureSentDateTime IS NULL )
	OR (ctl_el_comp.dqalertstatusid IS NOT NULL AND dq_as.EmailNotificationonSuccessSentDateTime IS NULL)
END