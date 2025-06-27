CREATE TABLE [DV].[SAT_RequestingSite_Adapt_Core] (
    [RequestingSiteHash] BINARY (32)    NULL,
    [RequestingSiteKey]  NVARCHAR (MAX) NULL,
    [RequestingSite]     NVARCHAR (MAX) NULL,
    [AddressLine1]       NVARCHAR (MAX) NULL,
    [AddressLine2]       NVARCHAR (MAX) NULL,
    [AddressLine3]       NVARCHAR (MAX) NULL,
    [AddressLine4]       NVARCHAR (MAX) NULL,
    [Town]               NVARCHAR (MAX) NULL,
    [County]             NVARCHAR (MAX) NULL,
    [Country]            NVARCHAR (MAX) NULL,
    [PostCode]           NVARCHAR (MAX) NULL,
    [ContentHash]        BINARY (32)    NULL,
    [ValidFrom]          DATETIME2 (0)  NULL,
    [ValidTo]            DATETIME2 (0)  NULL,
    [IsCurrent]          BIT            NULL
)
WITH (HEAP, DISTRIBUTION = HASH([RequestingSiteHash]));