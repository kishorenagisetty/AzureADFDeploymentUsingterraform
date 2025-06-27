CREATE EXTERNAL TABLE [DELTA].[ICONI_vBIRestart_GroupSessionSessionAttendance]
(
	[group_session_session_attendance_id] [int] NULL,
	[gsa_group_session_session_id] [int] NULL,
	[gsa_group_session_registration_id] [int] NULL,
	[gsa_session_title] [nvarchar](max) NULL,
	[gsa_outcome] [nvarchar](max) NULL,
	[gsa_trainer_notes] [nvarchar](max) NULL,
	[gsa_gss_date] [datetime2](0) NULL,
	[gsa_gss_attendance_notes] [nvarchar](max) NULL,
	[gsa_gss_id_check] [nvarchar](max) NULL,
	[ValidFrom] [datetime2](0) NULL,
	[ValidTo] [datetime2](0) NULL,
	[row_sha2] [nvarchar](max) NULL
)
WITH (DATA_SOURCE = [ADLG2_PSA],LOCATION = N'delta/ICONI/vBIRestart_GroupSessionSessionAttendance/IsCurrent=true',FILE_FORMAT = [parquet_file_format],REJECT_TYPE = VALUE,REJECT_VALUE = 0)
GO