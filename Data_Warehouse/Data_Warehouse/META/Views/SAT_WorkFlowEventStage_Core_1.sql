CREATE VIEW [META].[SAT_WorkFlowEventStage_Core] AS (

Select Distinct
	EWFES.WorkFlowStageID															AS WorkFlowStageHash,
	EWFES.WorkFlowStageID															AS WorkFlowStageKey,
	P.ProgrammeKey																	AS ProgrammeKey,
	EWFES.StageCategory																AS StageCategory,
	EWFES.Enquiry																	AS Enquiry,
	EWFES.Referral																	AS Referral,
	EWFES.PlanActive																AS PlanActive,
	EWFES.InWork																	AS InWork,
	EWFES.Closed																	AS Closed,
	'1900-01-02 00:00:00'												        	AS ValidFrom,
	getdate()																		AS ValidTo, 
	1																				AS IsCurrent -- Needs to come from source load

from 
	[ELT].[WorkFlowEventStage] AS  EWFES
	LEFT JOIN
	META.LINK_Programme_WorkFlowEventStage	AS P
	ON EWFES.Programme	 = P.ProgrammeKey

	);
GO

