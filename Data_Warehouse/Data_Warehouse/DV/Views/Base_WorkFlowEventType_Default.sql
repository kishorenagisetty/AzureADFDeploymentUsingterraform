CREATE VIEW [DV].[Base_WorkFlowEventType_Default]
AS SELECT
     CAST(0x0 AS BINARY(32)) [WorkFlowEventTypeHash]
	,Null [WorkFlowEventTypeKey]
	,CAST('Unknown' AS NVARCHAR(MAX)) [WorkFlowEventStageCategory]
	,CAST('Unknown' AS NVARCHAR(MAX)) [WorkFlowEventStageName]
	,null [WorkFlowEventID]
    ,CAST('Unknown' AS NVARCHAR(MAX)) [WorkFlowEventName]
	,CAST('Unknown' AS NVARCHAR(MAX)) [WorkFlowEventType];
GO

