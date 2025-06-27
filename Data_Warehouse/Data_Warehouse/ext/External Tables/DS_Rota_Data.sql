CREATE EXTERNAL TABLE [ext].[DS_Rota_Data] (
    [Date] VARCHAR (255) NULL,
    [Location] VARCHAR (255) NULL,
    [Region] VARCHAR (255) NULL,
    [Team] VARCHAR (255) NULL,
    [Manager Name] VARCHAR (255) NULL,
    [Name] VARCHAR (255) NULL,
    [Role] VARCHAR (255) NULL,
    [WorkEmail] VARCHAR (255) NULL,
    [EmployeeID] INT NULL,
    [PlannedAM] VARCHAR (255) NULL,
    [PlannedAMHours] DECIMAL (6, 2) NULL,
    [PlannedPM] VARCHAR (255) NULL,
    [PlannedPMHours] DECIMAL (6, 2) NULL,
    [ActualAM] VARCHAR (255) NULL,
    [ActualAMHours] DECIMAL (6, 2) NULL,
    [ActualPM] VARCHAR (255) NULL,
    [ActualPMHours] DECIMAL (6, 2) NULL
)
    WITH (
    DATA_SOURCE = [polybasestaging],
    LOCATION = N'DS_Rota/Processing/',
    FILE_FORMAT = [CSVFormat],
    REJECT_TYPE = VALUE,
    REJECT_VALUE = 0
    );





