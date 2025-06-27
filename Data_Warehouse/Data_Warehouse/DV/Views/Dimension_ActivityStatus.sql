CREATE VIEW [DV].[Dimension_ActivityStatus]
AS SELECT

[ActivityStatusHash]
,[RecordSource]
,[ActivityStatus]
,[ActivityStatusCode]

FROM ( 
		SELECT
			[ActivityStatusHash]
			,row_number() OVER (PARTITION BY [ActivityStatusHash] ORDER BY [ActivityStatusHash]) rn
			,[RecordSource]
			,[ActivityStatus]
			,[ActivityStatusCode]
			
			FROM [DV].Base_ActivityStatus
			) src
WHERE (rn = 1);
GO