CREATE VIEW [DV].[Base_EmploymentSite]
AS SELECT * FROM [DV].[Base_EmploymentSite_Default]
		UNION ALL
	SELECT * FROM [DV].[Base_EmploymentSite_Adapt]
		UNION ALL
	SELECT * FROM [DV].[Base_EmploymentSite_ICONI];
GO