CREATE VIEW [DV].[Dimension_ActivityType]
AS SELECT 

[ActivityTypeHash]
,[RecordSource]
,[ActivityType]
,[ActivityTypeCode]
,[ActivityRole]
,[ActivityCategory]

FROM ( 

	SELECT

	[ActivityTypeHash]
	,row_number() OVER (PARTITION BY [ActivityTypeHash] ORDER BY [ActivityTypeHash]) rn
	,[RecordSource]
	,[ActivityType]
	,[ActivityTypeCode]
	,[ActivityRole]
	,[ActivityCategory]

	FROM [DV].[Base_ActivityType]
	) src
WHERE (rn = 1);
GO