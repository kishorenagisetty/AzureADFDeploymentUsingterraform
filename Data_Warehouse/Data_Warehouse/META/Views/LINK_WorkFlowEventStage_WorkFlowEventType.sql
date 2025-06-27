CREATE VIEW [META].[LINK_WorkFlowEventStage_WorkFlowEventType] AS (
SELECT
	b.WorkFlowStageID										AS WorkFlowEventStageHash,
	a.WorkFlowEventTypeID									AS WorkFlowEventTypeHash,
	'ELT.WorkFlowEventStage'								AS RecordSource,
	'1900-01-02 00:00:00'									AS ValidFrom,
	'9999-12-31 00:00:00'									AS ValidTo,
	1														AS IsCurrent -- Needs to come from source load


	from 
	[ELT].[WorkFlowEventType] as a
	left join
	[ELT].[WorkFlowEventStage] as b
	on a.WorkFlowEventStageID = b.WorkFlowStageID

);
GO

