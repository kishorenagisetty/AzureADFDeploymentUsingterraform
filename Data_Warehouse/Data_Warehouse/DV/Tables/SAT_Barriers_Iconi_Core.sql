CREATE TABLE [DV].[SAT_Barriers_Iconi_Core] (
    [BarriersHash]       BINARY (32)    NULL,
    [BarriersKey]        NVARCHAR (100) NULL,
    [BarrierName]        NVARCHAR (MAX) NULL,
    [BarrierValue]       INT            NULL,
    [BarrierStatus]      INT            NULL,
    [BarrierAddedDate]   DATETIME2 (0)  NULL,
    [BarrierLastUpdated] DATETIME2 (0)  NULL,
    [ContentHash]        BINARY (32)    NULL,
    [ValidFrom]          DATETIME2 (0)  NULL,
    [ValidTo]            DATETIME2 (0)  NULL,
    [IsCurrent]          BIT            NULL
)
WITH (HEAP, DISTRIBUTION = HASH([BarriersHash]));
GO

