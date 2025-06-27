CREATE TABLE [DW].[D_Candidate] (
    [Candidate_Skey]          INT           NOT NULL,
    [CandidateBusKey]         INT           NOT NULL,
    [CustomerReferenceID]     INT           NULL,
    [Title]                   VARCHAR (255) NULL,
    [PostcodeSector]          VARCHAR (255) NULL,
    [County]                  VARCHAR (255) NULL,
    [Region]                  VARCHAR (255) NULL,
    [UniqueReferenceNumber]   VARCHAR (255) NULL,
    [IndividualLearnerNumber] VARCHAR (255) NULL,
    [ContactMethod]           VARCHAR (255) NULL,
    [Sys_LoadDate]            DATETIME      NULL,
    [Sys_LoadExpiryDate]      DATETIME      NULL,
    [Sys_IsCurrent]           BIT           NULL,
    [Sys_RunID]               INT           NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = REPLICATE);

