CREATE VIEW [DV].[Base_Time]
AS SELECT * FROM (
SELECT [Time_Skey] AS Time_Key
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
	    ,ROW_NUMBER() OVER (PARTITION BY [TIME]  ORDER BY TIME) AS TimeRank
  FROM [DW].[D_Time]
  ) T WHERE T.TimeRank = 1;