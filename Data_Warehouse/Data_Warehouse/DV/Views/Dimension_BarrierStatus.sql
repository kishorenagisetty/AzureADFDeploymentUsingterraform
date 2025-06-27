CREATE VIEW [DV].[Dimension_BarrierStatus]
AS SELECT

 [BarrierStatusHash]
,[RecordSource]
,[BarrierCode]
,[BarrierStatusName]

FROM (
		SELECT

		[BarrierStatusHash]
	   ,row_number() OVER (PARTITION BY [BarrierStatusHash] ORDER BY [BarrierStatusHash]) rn
	   ,[RecordSource]
	   ,[BarrierCode]
	   ,[BarrierStatusName]

		FROM [DV].[Base_BarrierStatus]
		) src
WHERE (rn = 1);