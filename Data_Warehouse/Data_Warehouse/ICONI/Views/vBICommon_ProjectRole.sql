CREATE VIEW [ICONI].[vBICommon_ProjectRole]
AS SELECT [user_id], [Project], [Role], [ValidFrom], [ValidTo], CAST(1 AS BIT) AS IsCurrent FROM DELTA.ICONI_vBICommon_ProjectRole;