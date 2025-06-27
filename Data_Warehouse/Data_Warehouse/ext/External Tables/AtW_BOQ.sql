CREATE EXTERNAL TABLE [ext].[AtW_BOQ] (
    [Metric] VARCHAR (255) NULL,
    [FinancialYear] VARCHAR (255) NULL,
    [FirstYear] INT NULL,
    [SecondYear] INT NULL,
    [Month] INT NULL,
    [Month_Skey] INT NULL,
    [Date_Skey] INT NULL,
    [Value] FLOAT (53) NULL
)
    WITH (
    DATA_SOURCE = [polybasestaging],
    LOCATION = N'AtW_BOQ/',
    FILE_FORMAT = [CSVFormat],
    REJECT_TYPE = VALUE,
    REJECT_VALUE = 0
    );

