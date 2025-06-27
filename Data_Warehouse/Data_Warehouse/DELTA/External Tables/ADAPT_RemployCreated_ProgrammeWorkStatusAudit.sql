CREATE EXTERNAL TABLE [DELTA].[ADAPT_RemployCreated_ProgrammeWorkStatusAudit] (
    [Audit_ID] BIGINT NULL,
    [Programme_ID] DECIMAL (16) NULL,
    [AuditDateTime] DATETIME2 (0) NULL,
    [WorkStatus] NVARCHAR (MAX) NULL,
    [ValidFrom] DATETIME2 (0) NULL,
    [ValidTo] DATETIME2 (0) NULL
)
    WITH (
    DATA_SOURCE = [ADLG2_PSA],
    LOCATION = N'delta/ADAPT/RemployCreated_ProgrammeWorkStatusAudit/IsCurrent=true',
    FILE_FORMAT = [parquet_file_format],
    REJECT_TYPE = VALUE,
    REJECT_VALUE = 0
    );

