CREATE TABLE [DV].[Dimension_Customer] (
    [Customer_Hash]      BINARY (32)    NULL,
    [Customer_Key]       NVARCHAR (100) NULL,
    [Title]              NVARCHAR (MAX) NULL,
    [First_Name]         NVARCHAR (MAX) NULL,
    [Last_Name]          NVARCHAR (MAX) NULL,
    [Gender]             NVARCHAR (MAX) NULL,
    [ContactStatus]      NVARCHAR (MAX) NULL,
    [Region]             NVARCHAR (MAX) NULL,
    [Type]               NVARCHAR (MAX) NULL,
    [HighEducationLevel] NVARCHAR (MAX) NULL,
    [IDType]             NVARCHAR (MAX) NULL,
    [Source]             NVARCHAR (MAX) NULL,
    [Status]             NVARCHAR (MAX) NULL,
    [SubType]            NVARCHAR (MAX) NULL,
    [Record_Source]      VARCHAR (20)   NULL
)
WITH (HEAP, DISTRIBUTION = ROUND_ROBIN);

