CREATE VIEW [META].[HUB_ForecastName]
AS (

SELECT
f.ForecastsNameKey                                    AS ForecastNameKey,
'ELT.ForecastsCohorts'				  	              AS RecordSource,
f.ValidFrom,
f.ValidTo,
f.IsCurrent
FROM
(
		SELECT 
		CONCAT_WS('|','META',[FileName]) AS ForecastsNameKey,
		row_number() OVER (PARTITION BY [FileName]	ORDER BY [FileName])  AS rn,
		'ELT.ForecastsCohorts'				  	              AS RecordSource,
		[ForecastDate]										  AS ValidFrom,
		'9999-12-31'										  AS ValidTo,
		'1'													  AS IsCurrent
		FROM 
		ELT.Forecasts
) f
WHERE rn = 1
UNION ALL
SELECT
fc.ForecastsNameKey,
'ELT.ForecastsCohorts'				  	              AS RecordSource,
fc.ValidFrom,
fc.ValidTo,
fc.IsCurrent
FROM
(
		SELECT 
		CONCAT_WS('|','META',[FileName]) AS ForecastsNameKey,
		row_number() OVER (PARTITION BY [FileName]	ORDER BY [FileName])  AS rn,
		'ELT.ForecastsCohorts'				  	              AS RecordSource,
		[ForecastDate]										  AS ValidFrom,
		'9999-12-31'										  AS ValidTo,
		'1'													  AS IsCurrent
		FROM 
		ELT.ForecastsCohort
) fc
WHERE rn = 1
);
GO

