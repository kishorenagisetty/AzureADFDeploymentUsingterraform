CREATE VIEW [DV].[Fact_EarningsAnalysis]
AS 

-- Author: 
-- Create date: DD/MM/YYY
-- Ticket Reference:  <Dev Ops Ticket Reference>
-- Description: <Description regarding object>
-- Revisions:
-- 03/08/2023 - <MK> <26306> <Earning Threshold is now gone up from 3952 to 4335 as per agreed with Paul Walters>

SELECT ParticipantID
	,Casehash
	,SUM(Cumulative_Earnings_To_Date) Cumulative_Earnings_To_Date
	,CASE 
		WHEN SUM(Cumulative_Earnings_To_Date) < 4335
			THEN 4335 - SUM(Cumulative_Earnings_To_Date)
		ELSE 0
		END RemainingEarnings
	,MIN(Target_Reached) AS projected_date
FROM (
	SELECT Casehash
		,ParticipantID
		,WorkingDayKey
		,Daily_Earnings
		,Cumulative_Earnings
		,CASE 
			WHEN Cumulative_Earnings >= 4335
				THEN WorkingDay
			ELSE NULL
			END Target_Reached
		,CASE 
			WHEN WorkingDay < GETDATE()
				THEN Daily_Earnings
			ELSE NULL
			END Cumulative_Earnings_To_Date
	FROM (
		SELECT Casehash
			,WorkingDayKey
			,d.[Date] WorkingDay
			,ParticipantID
			,([Working_Hours] * [Hourly_Rate]) Daily_Earnings
			,SUM([Working_Hours] * [Hourly_Rate]) OVER (
				PARTITION BY CaseHash ORDER BY WorkingDayKey ROWS BETWEEN UNBOUNDED PRECEDING
						AND CURRENT ROW
				) AS Cumulative_Earnings
		FROM [DV].[Fact_AssignmentEarnings] f
		INNER JOIN [DV].[Dimension_Participant] p ON (p.[ParticipantHash] = f.[ParticipantHash])
		INNER JOIN [DV].[Dimension_Date] d ON (f.WorkingDayKey = d.[Date_Key])
		WHERE ([Working_Hours] * [Hourly_Rate]) <> 0
			AND [Working_Hours] IS NOT NULL
			AND [Hourly_Rate] IS NOT NULL
		) subq
	) subq2
	where    ParticipantID <> 'Unknown'    --Paul H - Added this line to stop duplicates for cube build, needs investigation
GROUP BY CaseHash
	,ParticipantID;
GO
