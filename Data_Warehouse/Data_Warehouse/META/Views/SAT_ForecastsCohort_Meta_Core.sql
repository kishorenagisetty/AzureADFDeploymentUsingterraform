CREATE VIEW [META].[SAT_ForecastsCohort_Meta_Core]
AS 
/*--================================================================================
 Author			: 
 Created Date   :
 Created Ticket#:
 Description	: To get all the ForeCastCohort data from External table.
 Revisions:
 14/09/2023-SK-#28212-Adding 3 columns to support the issue withe dwh.Fact_ForeCastCohort.
--==================================================================================*/
(
SELECT 
CONCAT_WS('|','META',[ForecastsCohort_ID])   AS ForecastsCohortKey, 
'ELT.ForecastsCohort'						 AS RecordSource,
[CohortMonthNumber],
''											 AS ContractType,
''											 AS Initial,
''											 AS DDA,
[Conv],
[CumulConv],
[ForecastDate]								 AS ValidFrom,
CAST('9999-12-31' AS DATE)					 AS ValidTo,
'1'											 AS IsCurrent
FROM 
ELT.ForecastsCohort
);
GO

