CREATE VIEW [ADAPT].[SAT_OutcomeScore_Adapt_Core] AS SELECT
	CONCAT_WS('|','ADAPT',CAST(S.REFERENCE AS INT), S.BISUNIQUEID) AS OutcomeScoreKey
	, S.Q1_ANSWER		as Q1Answer
	, S.Q2_ANSWER		as Q2Answer
	, S.Q3_ANSWER		as Q3Answer
	, S.Q4_ANSWER		as Q4Answer
	, S.Q5_ANSWER		as Q5Answer
	, S.Q6_ANSWER		as Q6Answer
	, S.Q7_ANSWER		as Q7Answer
	, S.Q8_ANSWER		as Q8Answer
	, S.TOTAL			as Total
	, S.COLOR			as Colour
	, S.ANSWER_DATE		as AnswerDate
	, S.ValidFrom
	, S.ValidTo
	, S.IsCurrent 
FROM ADAPT.PROP_SOC_IMP_HIST S;