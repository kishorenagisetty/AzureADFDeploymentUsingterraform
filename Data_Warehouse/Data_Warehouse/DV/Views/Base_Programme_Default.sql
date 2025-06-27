CREATE VIEW [DV].[Base_Programme_Default]
AS SELECT 
	CONVERT(CHAR(66),CAST(0x0 AS BINARY(32)) ,1) AS ProgrammeHash, 
	CAST('Unknown' AS NVARCHAR(MAX)) AS RecordSource, 
	CAST('Unknown' AS NVARCHAR(MAX)) AS ProgrammeName, 
	CAST('Unknown' AS NVARCHAR(MAX)) AS ProgrammeGroup, 
	CAST('Unknown' AS NVARCHAR(MAX)) AS ProgrammeCategory;
GO

