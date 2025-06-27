CREATE VIEW [DV].[Dimension_AssignmentEarnings]
AS SELECT

 [AssignmentEarningPatternHash]
,[AssignmentHash]
,[EarningsKey]
,[SalaryUnit]
,[DayOfWeek]
,[DailyRateType]

	FROM (
			SELECT 
				 [AssignmentEarningPatternHash]
				 ,row_number() OVER (PARTITION BY [AssignmentEarningPatternHash] ORDER BY [AssignmentEarningPatternHash]) rn
				,[AssignmentHash]
				,[EarningsKey]
				,[SalaryUnit]
				,[DayOfWeek]
				,[DailyRateType]
				FROM [DV].[Base_AssignmentEarnings]
		) src
WHERE (rn = 1);