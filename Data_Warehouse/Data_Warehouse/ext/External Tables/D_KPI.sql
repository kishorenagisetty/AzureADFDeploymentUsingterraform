CREATE EXTERNAL TABLE [ext].[D_KPI] (
    [KPIArea] VARCHAR (255) NULL,
    [KPIReference] VARCHAR (255) NULL,
    [KPIName] VARCHAR (255) NULL,
    [KPIDescriptionOfStandardRequired] VARCHAR (255) NULL,
    [KPIType] VARCHAR (255) NULL,
    [KPIStartType] VARCHAR (255) NULL,
    [KPIStartEventType] VARCHAR (255) NULL,
    [KPIEndType] VARCHAR (255) NULL,
    [KPIEndEventType] VARCHAR (255) NULL,
    [KPIDurationType] VARCHAR (255) NULL,
    [KPIDuration] INT NULL,
    [KPIGreenStart] DECIMAL (3, 2) NULL,
    [KPIGreenEnd] DECIMAL (3, 2) NULL,
    [KPIAmberStart] DECIMAL (3, 2) NULL,
    [KPIAmberEnd] DECIMAL (3, 2) NULL,
    [KPIRedStart] DECIMAL (3, 2) NULL,
    [KPIRedEnd] DECIMAL (3, 2) NULL,
    [MonitoredBy] VARCHAR (255) NULL,
    [ComplianceRiskRating] VARCHAR (255) NULL,
    [Measurement] VARCHAR (255) NULL,
    [DrillDown] VARCHAR (255) NULL,
    [Presentation1] VARCHAR (255) NULL,
    [Presentation2] VARCHAR (255) NULL
)
    WITH (
    DATA_SOURCE = [polybasestaging],
    LOCATION = N'D_KPI/',
    FILE_FORMAT = [TextFileFormat],
    REJECT_TYPE = VALUE,
    REJECT_VALUE = 0
    );

