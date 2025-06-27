CREATE VIEW [DV].[Base_WorkFlowEventType]
AS select * FROM
    [DV].[Base_WorkFlowEventType_Meta]	
union
select * FROM
    [DV].[Base_WorkFlowEventType_Default];
GO

