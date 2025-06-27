CREATE VIEW [META].[HUB_WorkFlowEventType]
AS (

Select Distinct
	WorkFlowEventTypeID					AS WorkFlowEventTypeHash,
	'ELT.WorkFlowEventType'				AS RecordSource,
	'1900-01-02 00:00:00'				AS ValidFrom, 
	'9999-12-31 00:00:00'				AS ValidTo, 
	1									AS IsCurrent 


from 
	[ELT].[WorkFlowEventType]

	


	);
GO

