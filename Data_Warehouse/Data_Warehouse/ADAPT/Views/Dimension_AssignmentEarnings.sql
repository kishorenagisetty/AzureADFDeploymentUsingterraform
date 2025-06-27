CREATE VIEW [ADAPT].[Dimension_AssignmentEarnings] AS SELECT

		CONVERT(CHAR(66),ISNULL(A.AssignmentEarningPatternHash,CAST(0x0 AS BINARY(32))),1)	AS AssignmentEarningPatternHash,
		CONVERT(CHAR(66),ISNULL(A.AssignmentKey,CAST(0x0 AS BINARY(32))),1)					AS AssignmentHash,
		CONVERT(CHAR(66),ISNULL(A.EarningsKey,CAST(0x0 AS BINARY(32))),1)					AS EarningsKey,
		'ADAPT' AS Program,
		'Hourly' AS SalaryUnit,
		[DayOfWeek]	AS [DayOfWeek],
		'Actual' AS DailyRateType

	FROM
		BV.SAT_AssignmentEarningPattern_Adapt_Core										AS A;
