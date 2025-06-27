CREATE TABLE [ELT].[PSATableRowCountsTemp]
(
	[SchemaName] [varchar](100) NULL,
	[TableName] [varchar](100) NULL,
	[RowCount] [int] NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN)
GO
