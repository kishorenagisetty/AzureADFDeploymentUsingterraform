CREATE VIEW [DV].[Dimension_CaseStatus]
AS SELECT 

 [CaseStatusHash]
,[CaseStatus]
,[RecordSource]

FROM (
		SELECT 
			  [CaseStatusHash]
			 ,row_number() OVER (PARTITION BY [CaseStatusHash] ORDER BY [CaseStatusHash]) rn
			 ,[CaseStatus]
			 ,[RecordSource]

			 		FROM [DV].[Base_CaseStatus]
		) src
WHERE (rn = 1);
GO

