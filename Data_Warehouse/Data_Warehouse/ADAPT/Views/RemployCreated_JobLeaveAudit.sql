CREATE VIEW [ADAPT].[RemployCreated_JobLeaveAudit]
AS SELECT [Id], [AuditDate], [Programme_ID], [Job_ID], [LeaveDate], [LeaveReason], [ValidFrom], [ValidTo], [row_sha2], CAST(1 AS BIT) AS IsCurrent FROM DELTA.ADAPT_RemployCreated_JobLeaveAudit;
GO