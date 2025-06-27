CREATE TABLE [DV].[LINK_Case_Barriers] (
    [Case_BarriersHash] BINARY (32)   NULL,
    [CaseHash]          BINARY (32)   NULL,
    [BarriersHash]      BINARY (32)   NULL,
    [RecordSource]      VARCHAR (50)  NULL,
    [ValidFrom]         DATETIME2 (0) NULL
)
WITH (HEAP, DISTRIBUTION=HASH([Case_BarriersHash]) ) 
GO;


