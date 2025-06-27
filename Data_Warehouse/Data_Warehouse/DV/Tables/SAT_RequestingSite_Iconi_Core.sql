CREATE TABLE [DV].[SAT_RequestingSite_Iconi_Core] (
    [RequestingSiteHash]             BINARY (32)    NULL,
    [RequestingSiteKey]              NVARCHAR (MAX) NULL,
    [RequestingSiteName]             NVARCHAR (MAX) NULL,
    [RequestingSiteDistrict]         NVARCHAR (MAX) NULL,
    [RequestingSiteContractAreaName] NVARCHAR (MAX) NULL,
    [ContentHash]                    BINARY (32)    NULL,
    [ValidFrom]                      DATETIME2 (0)  NULL,
    [ValidTo]                        DATETIME2 (0)  NULL,
    [IsCurrent]                      BIT            NULL
)
WITH (HEAP, DISTRIBUTION = HASH([RequestingSiteHash]));
GO

