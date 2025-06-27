CREATE TABLE [ETL].[Tables_To_Load] (
    [ID]                INT            IDENTITY (1, 1) NOT NULL,
    [Source_Name]       VARCHAR (128)  NOT NULL,
    [Source_Schema]     VARCHAR (128)  NOT NULL,
    [Source_Table]      VARCHAR (128)  NOT NULL,
    [Dest_Schema]       VARCHAR (128)  NOT NULL,
    [Dest_table]        VARCHAR (128)  NOT NULL,
    [Columns]           VARCHAR (5000) NOT NULL,
    [WatermarkColumn]   VARCHAR (128)  NULL,
    [WatermarkValue]    VARCHAR (128)  NULL,
    [Enabled]           BIT            NOT NULL,
    [Distribution_Type] VARCHAR (255)  NULL,
    [ObjectType]        VARCHAR (2)    NULL,
    [Dest_Table_Prefix] VARCHAR (128)  NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);



