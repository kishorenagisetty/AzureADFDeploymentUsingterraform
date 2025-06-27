CREATE TABLE [DV].[SAT_Entity_SoftDelete_Adapt_Core]
(
    [EntityHash] [binary](32) NULL,
    [EntityKey] [nvarchar](100) NULL,
    [RecordSource] [varchar](18) NOT NULL,
    [STATUS] [nvarchar](max) NULL,
    [CREATED_BY] [bigint] NULL,
    [UPDATED_BY] [bigint] NULL,
    [DELETED_BY] [bigint] NULL,
    [ContentHash] [binary](32) NULL,
    [ValidFrom] [datetime2](0) NULL,
    [ValidTo] [datetime2](0) NULL,
    [IsCurrent] [bit] NULL
)
WITH
(
    DISTRIBUTION = HASH ( [EntityHash] ),
    HEAP
)
GO