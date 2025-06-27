CREATE TABLE [DV].[SAT_Metric_Meta_Core] (
    [MetricHash]  BINARY (32)    NULL,
    [MetricKey]   NVARCHAR (100) NULL,
    [metricName]  VARCHAR (50)   NULL,
    [ContentHash] BINARY (32)    NULL,
    [ValidFrom]   DATETIME2 (0)  NULL,
    [ValidTo]     DATETIME2 (0)  NULL,
    [IsCurrent]   BIT            NULL
)
WITH (HEAP, DISTRIBUTION = HASH([MetricHash]));
GO

