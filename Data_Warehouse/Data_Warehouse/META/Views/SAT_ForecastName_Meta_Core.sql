CREATE VIEW [META].[SAT_ForecastName_Meta_Core]
AS (
SELECT
f.ForecastsNameKey,
f.Filename,
f.DateProvided,
f.Dateuploaded,
f.ValidFrom,
f.ValidTo,
f.IsCurrent
FROM
(
		SELECT 
		CONCAT_WS('|','META',[FileName]) AS ForecastsNameKey,
		row_number() OVER (PARTITION BY [FileName]	ORDER BY [FileName])  AS rn,
		[FileName]									  AS Filename,
		'2022-03-01'										  AS DateProvided,
		'2022-03-02'										  AS Dateuploaded,
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
fc.Filename,
fc.DateProvided,
fc.Dateuploaded,
fc.ValidFrom,
fc.ValidTo,
fc.IsCurrent
FROM
(
		SELECT 
		CONCAT_WS('|','META',[FileName]) AS ForecastsNameKey,
		row_number() OVER (PARTITION BY [FileName]	ORDER BY [FileName])  AS rn,
		[FileName]									  AS Filename,
		'2022-03-01'										  AS DateProvided,
		'2022-03-02'										  AS Dateuploaded,
		[ForecastDate]										  AS ValidFrom,
		'9999-12-31'										  AS ValidTo,
		'1'													  AS IsCurrent
		FROM 
		ELT.ForecastsCohort
) fc
WHERE rn = 1

);
GO

