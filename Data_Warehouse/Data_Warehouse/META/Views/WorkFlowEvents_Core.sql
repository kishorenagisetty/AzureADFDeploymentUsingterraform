CREATE VIEW [META].[WorkFlowEvents_Core] AS SELECT
	CaseKey,
	CaseHash,
	ReferralHash,
	ProgrammeKey,
	Programmehash,
	WorkFlowEventTypeKey,
	WorkFlowEventID,
	WorkFlowEventPreviousEventID,
	WorkFlowEventName,
	WorkFlowEventDate,
	WorkFlowEventEstimatedStartDate,
	WorkFlowEventEstimatedEndDate,
	EventEndDate,
	WorkFlowEventUser,
	InOutWork
FROM STG.WorkFlowEvents_SLA_Repeated_TEMP;
GO

