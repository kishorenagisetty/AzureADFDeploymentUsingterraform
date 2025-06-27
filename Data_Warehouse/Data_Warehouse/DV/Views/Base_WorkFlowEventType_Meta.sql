CREATE VIEW [DV].[Base_WorkFlowEventType_Meta]
AS select 
	 CONVERT(CHAR(66),ISNULL(WorkFlowEventTypeHash, CAST(0x0 AS BINARY(32))),1) [WorkFlowEventTypeHash]
	,[WorkFlowEventTypeKey]
	,[WorkFlowEventStageCategory]
	,[WorkFlowEventStageName]
	,[WorkFlowEventID]
    ,[WorkFlowEventName]
	,[WorkFlowEventType]
from [DV].[SAT_WorkFlowEventType_Core]
where IsCurrent = 1;
GO

