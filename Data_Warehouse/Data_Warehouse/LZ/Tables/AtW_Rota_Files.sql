CREATE TABLE [LZ].[AtW_Rota_Files] (
    [Date]           VARCHAR (255)  NULL,
    [Location]       VARCHAR (255)  NULL,
    [Region]         VARCHAR (255)  NULL,
    [Team]           VARCHAR (255)  NULL,
    [ManagerName]    VARCHAR (255)  NULL,
    [Name]           VARCHAR (255)  NULL,
    [Role]           VARCHAR (255)  NULL,
    [WorkEmail]      VARCHAR (255)  NULL,
    [EmployeeID]     INT            NULL,
    [PlannedAM]      VARCHAR (255)  NULL,
    [PlannedAMHours] DECIMAL (6, 2) NULL,
    [PlannedPM]      VARCHAR (255)  NULL,
    [PlannedPMHours] DECIMAL (6, 2) NULL,
    [ActualAM]       VARCHAR (255)  NULL,
    [ActualAMHours]  DECIMAL (6, 2) NULL,
    [ActualPM]       VARCHAR (255)  NULL,
    [ActualPMHours]  DECIMAL (6, 2) NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);

