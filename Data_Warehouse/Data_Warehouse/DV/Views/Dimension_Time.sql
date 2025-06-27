CREATE VIEW [DV].[Dimension_Time]
AS SELECT 
[Time_Key]
,[Time]
,[Hour]
,[MilitaryHour]
,[Minute]
,[Second]
,[AmPm]
,[StandardTime]
,[Time_Hour_Quarter]
,[Sys_LoadDate]
,[Sys_ModifiedDate]
,[TimeRank]

FROM (
		 SELECT 
		 [Time_Key]
		,row_number() OVER (PARTITION BY [Time_Key] ORDER BY [Time_Key]) rn
		,[Time]
		,[Hour]
		,[MilitaryHour]
		,[Minute]
		,[Second]
		,[AmPm]
		,[StandardTime]
		,[Time_Hour_Quarter]
		,[Sys_LoadDate]
		,[Sys_ModifiedDate]
		,[TimeRank]

		FROM [DV].[Base_Time]
		) src
WHERE (rn = 1);
GO
