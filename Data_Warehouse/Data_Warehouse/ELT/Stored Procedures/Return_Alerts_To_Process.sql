CREATE PROC [ELT].[Return_Alerts_To_Process] AS
BEGIN
SELECT *
FROM ELT.DQ_Alert
WHERE Active = 'Y'

END