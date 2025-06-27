CREATE VIEW [DV].[Base_Barrier_Default]
AS SELECT
CONVERT(CHAR(66),CAST(0x0 AS BINARY(32)) ,1)	AS BarrierHash,
CAST('0' AS NVARCHAR(MAX))						AS BarrierKey,
CAST('Unknown' AS VARCHAR(50))					AS RecordSource,
CAST('0' AS NVARCHAR(MAX))						AS BarrierCode,
CAST('Unknown' AS NVARCHAR(MAX))      			AS BarrierName,
CAST('Unknown' AS NVARCHAR(MAX))				AS BarrierStatus,
CAST('Unknown' AS NVARCHAR(MAX))				AS BarrierCategory,
0												AS BarrierIsDisengagement,
0  												AS BarrierScore,
CAST('1900-01-01' AS DATE)						AS BarrierStartDate,
CAST('9999-12-31' AS DATE)						AS BarrierEndDate,
0												AS IsCurrent;
GO

