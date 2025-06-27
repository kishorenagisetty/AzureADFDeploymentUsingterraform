CREATE PROC [ELT].[SelectAASLatestTime] AS


select * from ELT.ImportJsonAAS


/****** Object:  StoredProcedure [ELT].[InsertAASRefreshStatus]    Script Date: 18/04/2023 20:12:44 ******/
SET ANSI_NULLS ON