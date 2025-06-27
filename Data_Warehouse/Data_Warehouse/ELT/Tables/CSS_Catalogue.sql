CREATE TABLE [ELT].[CSS_Catalogue] (
    [CSS_ContractRefNo]        NVARCHAR (10)   NULL,
    [ProgrammeName]            NVARCHAR (500)  NULL,
    [CSSName]                  NVARCHAR (500)  NULL,
    [DWP_Description]          NVARCHAR (1000) NULL,
    [DWP_DueDate]              NVARCHAR (1000) NULL,
    [DWP_SuccessCriteria]      NVARCHAR (1000) NULL,
    [DWP_HowManyRecords]       NVARCHAR (1000) NULL,
    [DWP_HowManyRecordsExempt] NVARCHAR (1000) NULL,
    [DWP_HowManyRecordsNotes]  NVARCHAR (1000) NULL,
    [CSS_SortOrder]            INT             NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);

