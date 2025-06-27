CREATE EXTERNAL TABLE [DELTA].[ADAPT_RemployCreated_JobLeaveAudit] (
    [Id] BIGINT NULL,
    [AuditDate] DATETIME2 (0) NULL,
    [Programme_ID] DECIMAL (20) NULL,
    [Job_ID] DECIMAL (20) NULL,
    [LeaveDate] DATE NULL,
    [LeaveReason] NVARCHAR (MAX) NULL,
    [ValidFrom] DATETIME2 (0) NULL,
    [ValidTo] DATETIME2 (0) NULL,
    [row_sha2] NVARCHAR (MAX) NULL
)
    WITH (
    DATA_SOURCE = [ADLG2_PSA],
    LOCATION = N'delta/ADAPT/RemployCreated_JobLeaveAudit/IsCurrent=true',
    FILE_FORMAT = [parquet_file_format],
    REJECT_TYPE = VALUE,
    REJECT_VALUE = 0
    );


GO