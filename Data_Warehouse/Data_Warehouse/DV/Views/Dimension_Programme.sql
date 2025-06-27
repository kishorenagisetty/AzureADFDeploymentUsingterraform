CREATE VIEW [DV].[Dimension_Programme]
AS SELECT 
 [ProgrammeHash]
,[RecordSource]
,[ProgrammeName]
,[ProgrammeGroup]
,[ProgrammeCategory]

FROM (SELECT  
		 [ProgrammeHash]
		,row_number() OVER (PARTITION BY [ProgrammeHash] ORDER BY [ProgrammeHash]) rn
		,[RecordSource]
		,[ProgrammeName]
		,[ProgrammeGroup]
		,[ProgrammeCategory]

		FROM [DV].[Base_Programme]
		) src
WHERE (rn = 1);
GO

