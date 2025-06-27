CREATE TABLE [LZ].[AtW_vw_cm_customer] (
    [customerId]              INT           NULL,
    [caseId]                  INT           NULL,
    [titleId]                 INT           NULL,
    [countyId]                INT           NULL,
    [regionId]                INT           NULL,
    [urn]                     VARCHAR (255) NULL,
    [prapNumber]              VARCHAR (255) NULL,
    [occupation]              VARCHAR (255) NULL,
    [jobTitle]                VARCHAR (255) NULL,
    [isApprentice]            BIT           NULL,
    [individualLearnerNumber] VARCHAR (255) NULL,
    [contactMethodId]         INT           NULL,
    [PostCode_Sector]         VARCHAR (255) NULL,
    [Sys_RunID]               INT           NULL,
    [Sys_LoadDate]            DATETIME      NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

