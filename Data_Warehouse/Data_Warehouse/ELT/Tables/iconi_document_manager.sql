CREATE TABLE [ELT].[iconi_document_manager] (
    [adf_process_key]     VARCHAR (500) NOT NULL,
    [document_start_date] DATETIME      NOT NULL,
    [document_end_date]   DATETIME      NOT NULL,
    [documents_processed] INT           NOT NULL
)
WITH (HEAP, DISTRIBUTION = HASH([adf_process_key]));

