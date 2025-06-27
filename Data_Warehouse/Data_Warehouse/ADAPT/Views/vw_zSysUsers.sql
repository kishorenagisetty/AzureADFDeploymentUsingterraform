CREATE VIEW [ADAPT].[vw_zSysUsers]
AS SELECT [UserID], [FullName], [UserName], [Initials], [Status], [EmailAddress], [UserType], [CanConfig], [ADUserName], [PasswordChangeDate], [ValidFrom], [ValidTo], [row_sha2], CAST(1 AS BIT) AS IsCurrent FROM DELTA.ADAPT_vw_zSysUsers;
GO