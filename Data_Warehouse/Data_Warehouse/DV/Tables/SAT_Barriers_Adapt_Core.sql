CREATE TABLE [DV].[SAT_Barriers_Adapt_Core] (
    [BarriersHash]     BINARY (32)    NULL,
    [BarriersKey]      NVARCHAR (100) NULL,
    [RecordSource]     VARCHAR (22)   NOT NULL,
    [BarrierStartDate] DATETIME2 (0)  NULL,
    [BarrierEndDate]   DATETIME2 (0)  NULL,
    [BarrierStatus]    DECIMAL (20)   NULL,
    [BarrierName]      DECIMAL (20)   NULL,
    [BarrierCreatedDate] DATETIME2 (0)  NULL, 
    [BarrierCreatedBy] BIGINT NULL,
    [ContentHash]      BINARY (32)    NULL,
    [ValidFrom]        DATETIME2 (0)  NULL,
    [ValidTo]          DATETIME2 (0)  NULL,
    [IsCurrent]        BIT            NULL
)
WITH (HEAP, DISTRIBUTION = HASH([BarriersHash]));

