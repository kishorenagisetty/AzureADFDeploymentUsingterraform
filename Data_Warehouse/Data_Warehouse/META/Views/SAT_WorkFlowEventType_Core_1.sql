CREATE VIEW [META].[SAT_WorkFlowEventType_Core]
AS (

SELECT
	WorkFlowEventTypeID				 	AS WorkFlowEventTypeKey,
	WorkFlowEventProgramme				AS WorkFlowEventProgramme,
	WorkFlowEventStageID				AS WorkFlowEventStageID,
	WorkFlowEventStageCategory			AS WorkFlowEventStageCategory,
	WorkFlowEventStageName				AS WorkFlowEventStageName,
	WorkFlowEventID						AS WorkFlowEventID,
	WorkFlowEventName					AS WorkFlowEventName,
	WorkFlowEventType					AS WorkFlowEventType,
	CorrospondanceName					AS CorrospondanceName,
	DocumentName						AS DocumentName,
	ActivityName						AS ActivityName,
	DocumentTrackingName				AS DocumentTrackingName,
	WorkFlowEventDate					AS WorkFlowEventDate,			
	WorkFlowEventDueDate				AS WorkFlowEventDueDate,
	WorkFlowPreviousEventID				AS WorkFlowEventPreviousEventID,
	WorkFlowEventSLAType				AS WorkFlowEventSLAType,
	WorkFlowEventSLADurationType		AS WorkFlowEventSLADurationType,
	WorkFlowEventSLAFrom				AS WorkFlowEventSLAFrom,
	WorkFlowEventSLADuration			AS WorkFlowEventSLADuration,
	WorkFlowEventActionType				AS WorkFlowEventActionType,
	WorkFlowEventCSSRelated				AS WorkFlowEventCSSRelated,
	WorkFlowEventRecurring				AS WorkFlowEventRecurring,
	WorkFlowEventTypeCount				AS WorkFlowEventTypeCount,
	WorkFlowEventTypeExit				AS WorkFlowEventTypeExit,
	SkippableEventID					AS SkippableEventID,
	'1900-01-02 00:00:00'				AS ValidFrom, 
	getdate()							AS ValidTo, 
	1									AS IsCurrent 


FROM 
	[ELT].[WorkFlowEventType]

	);
GO


