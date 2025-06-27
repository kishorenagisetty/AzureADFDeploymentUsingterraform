CREATE VIEW [META].[LINK_Programme_WorkFlowEventStage] AS (
SELECT
	WFES.Programme											AS ProgrammeKey,
	WFES.WorkFlowStageID 									AS WorkFlowStageKey,
	'ELT.WorkFlowEventStage'								AS RecordSource,
	'1900-01-02 00:00:00'									AS ValidFrom,
	'9999-12-31 00:00:00'									AS ValidTo,
	1														AS IsCurrent -- Needs to come from source load

FROM
	[ELT].[WorkFlowEventStage] as WFES

);
GO

