CREATE TABLE [ETL].[TrackDataChanges] (
    [TrackDataChangesID] INT           NULL,
    [Source_Name]        VARCHAR (128) NULL,
    [Source_Schema]      VARCHAR (128) NOT NULL,
    [Stage_Schema]       VARCHAR (128) NOT NULL,
    [Dest_Schema]        VARCHAR (128) NOT NULL,
    [Table]              VARCHAR (128) NOT NULL,
    [ID]                 VARCHAR (128) NOT NULL,
    [Key]                VARCHAR (128) NOT NULL,
    [Enabled]            BIT           NOT NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);



