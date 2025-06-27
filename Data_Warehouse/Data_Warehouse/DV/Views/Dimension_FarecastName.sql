CREATE VIEW [DV].[Dimension_ForecastName]
AS SELECT 
CONVERT(CHAR(66),ISNULL(satfn.ForecastNameHash,CAST(0x0 AS BINARY(32))),1) AS ForecastNameHash
,satfn.ForecastNameKey
,satfn.Filename
,satfn.DateProvided
,satfn.Dateuploaded
,satfn.ContentHash
,satfn.ValidFrom
,satfn.ValidTo
,satfn.IsCurrent
FROM [DV].[HUB_ForecastName] hubfn
left join [DV].[SAT_ForecastName_Meta_Core] satfn on (satfn.ForecastNameHash = hubfn.ForecastNameHash);
GO

