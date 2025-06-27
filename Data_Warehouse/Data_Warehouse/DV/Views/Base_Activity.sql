CREATE VIEW [DV].[Base_Activity]
AS SELECT *
FROM DV.Base_Activity_Default

UNION ALL

SELECT * FROM DV.Base_Activity_Iconi

UNION ALL

SELECT * FROM DV.Base_Activity_Adapt;
GO