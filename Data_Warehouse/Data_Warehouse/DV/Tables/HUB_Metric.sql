CREATE TABLE [DV].[HUB_Metric] (
    [MetricHash]   BINARY (32)    NULL,
    [MetricKey]    NVARCHAR (100) NULL,
    [RecordSource] VARCHAR (50)   NULL,
    [ValidFrom]    DATETIME2 (0)  NULL
)
WITH (HEAP, DISTRIBUTION = HASH([MetricHash]));
GO

