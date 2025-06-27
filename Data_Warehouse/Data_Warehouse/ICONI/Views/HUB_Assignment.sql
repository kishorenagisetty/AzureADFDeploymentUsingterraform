CREATE VIEW [ICONI].[HUB_Assignment] AS SELECT 
CONCAT_WS('|','ICONI',A.outcome_id) AS AssignmentKey,
'ICONI.Assignment' AS RecordSource,
A.ValidFrom,
A.ValidTo,
A.IsCurrent
FROM ICONI.vBIRestart_Outcome A;
GO

