CREATE VIEW [META].[LINK_Forecasts_DeliverySite]
AS SELECT 
CONCAT_WS('|','META',[Forecasts_ID])		   AS ForecastsKey,
CONCAT('-', [Forecasts_ID],'-FORECASTTEST') AS DeliverySiteKey,
--delysite.DeliverySiteKey					   AS DeliverySiteKey,
'ELT.Forecasts'								   AS RecordSource,
[ForecastDate]							   	   AS ValidFrom,
CAST('9999-12-31' AS DATE)					   AS ValidTo,
'1'											   AS IsCurrent
FROM 
	ELT.Forecasts f 

LEFT JOIN
(
SELECT
 d.DeliverySiteHash
,d.DeliverySiteKey
,d.Region
,d.Zone
FROM	
		(
		SELECT 
		CONVERT(CHAR(66),H.DeliverySiteHash ,1) AS DeliverySiteHash
		,H.DeliverySiteKey AS DeliverySiteKey
		--,row_number() OVER (PARTITION BY ISNULL(LK.[ReportingRegion],'South East Wales') ORDER BY ISNULL(LK.[ReportingRegion],'South East Wales')) rnreg
		--,row_number() OVER (PARTITION BY ISNULL(LK.[ReportingZone], 'ES Cardiff WHP') ORDER BY ISNULL(LK.[ReportingZone], 'ES Cardiff WHP')) rnzon
		--,ISNULL(LK.[ReportingRegion],'South East Wales') AS Region
		--,ISNULL(LK.[ReportingZone], 'ES Cardiff WHP') AS Zone

		,ROW_NUMBER() OVER (PARTITION BY LK.[ReportingRegion] ORDER BY LK.[ReportingRegion]) rnreg
		,ROW_NUMBER() OVER (PARTITION BY LK.[ReportingZone] ORDER BY LK.[ReportingZone]) rnzon
		,LK.[ReportingRegion] AS Region
		,LK.[ReportingZone] AS Zone
		FROM 
			DV.HUB_DeliverySite H
			LEFT JOIN DV.SAT_DeliverySite_Adapt_Core S_AC ON H.DeliverySiteHash = S_AC.DeliverySiteHash AND S_AC.IsCurrent = 1
			LEFT JOIN DV.SAT_DeliverySite_LKRegionZones LK ON LK.DeliverySiteHash = H.DeliverySiteHash AND LK.IsCurrent = 1
			WHERE H.RecordSource = 'ADAPT.PROP_CLIENT_GEN'			
		) d

WHERE d.rnreg = 1 AND rnzon = 1
) delysite
ON f.Region = delysite.region AND f.zone = delysite.zone;
GO
