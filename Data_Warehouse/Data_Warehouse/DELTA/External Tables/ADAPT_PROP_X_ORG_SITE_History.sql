﻿CREATE EXTERNAL TABLE [DELTA].[ADAPT_PROP_X_ORG_SITE_History] (
    [BISUNIQUEID] BIGINT NULL,
    [ORG] DECIMAL (16) NULL,
    [SITE] DECIMAL (16) NULL,
    [ValidFrom] DATETIME2 (0) NULL,
    [ValidTo] DATETIME2 (0) NULL,
    [row_sha2] NVARCHAR (MAX) NULL
)
    WITH (
    DATA_SOURCE = [ADLG2_PSA],
    LOCATION = N'delta/ADAPT/PROP_X_ORG_SITE/IsCurrent=false',
    FILE_FORMAT = [parquet_file_format],
    REJECT_TYPE = VALUE,
    REJECT_VALUE = 0
    );

