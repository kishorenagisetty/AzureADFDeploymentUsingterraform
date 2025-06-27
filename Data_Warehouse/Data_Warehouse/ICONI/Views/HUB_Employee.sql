CREATE VIEW [ICONI].[HUB_Employee] AS SELECT 
CONCAT_WS('|','ICONI',E.[user_id]) AS EmployeeKey,
'ICONI.User' AS RecordSource,
E.ValidFrom,
E.ValidTo,
E.IsCurrent
FROM [ICONI].[vBICommon_User] E;