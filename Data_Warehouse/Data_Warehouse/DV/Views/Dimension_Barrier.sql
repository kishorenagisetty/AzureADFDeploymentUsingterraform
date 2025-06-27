CREATE VIEW [DV].[Dimension_Barrier]
AS SELECT
 [BarrierHash]
,[RecordSource]
,[BarrierCode]
,[BarrierName]
,[BarrierCategory]
,[BarrierIsDisengagement] 

FROM (
		SELECT
			 [BarrierHash]
			,row_number() OVER (PARTITION BY [BarrierHash] ORDER BY [BarrierHash]) rn
			,[RecordSource]
			,[BarrierCode]
			,[BarrierName]
			,[BarrierCategory]
			,[BarrierIsDisengagement] 

		FROM [DV].[Base_Barrier] 

		) src
WHERE (rn = 1);
GO

