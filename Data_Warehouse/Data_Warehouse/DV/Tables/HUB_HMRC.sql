CREATE TABLE [DV].[HUB_HMRC] (
    [HMRCHash]     BINARY (32)    NULL,
    [HMRCKey]      NVARCHAR (100) NULL,
    [RecordSource] VARCHAR (50)   NULL,
    [ValidFrom]    DATETIME2 (0)  NULL
)
WITH (HEAP, DISTRIBUTION = HASH([HMRCHash]));
GO