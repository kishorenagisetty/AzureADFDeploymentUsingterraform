CREATE PROC [ELT].[Return_Track_Data_Changes_Tables_To_Load] @Source_Name [varchar](128) AS
BEGIN
SELECT *
FROM [ETL].[TrackDataChanges]
WHERE Enabled = 1
AND Source_Name = @Source_Name
END