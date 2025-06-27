CREATE VIEW [ICONI].[SAT_Earnings_ICONI_Core] AS SELECT 
		CONCAT_WS('|','ICONI',CAST(outcome_earnings_id AS INT)) AS [EarningPatternKey],
		out_earn_date_to as [EarningPatternEffectiveTo],
		out_earn_hours_per_week as [EarningPatternWeeklyHours],
		out_earn_date_from as [EarningPatternEffectiveFrom],
		out_earn_updated_date as [EarningPatternDateChanged],
		out_earn_entity_id as [OutcomeEntityID],
		out_earn_salary_amount as [EarningPatternPaymentAmount],
		out_earn_salary_unit as [EarningPatternPaymentFrequency],
		out_earn_date_from as [ValidFrom]

FROM 
		DELTA.ICONI_vBICommon_Outcome_Earnings;