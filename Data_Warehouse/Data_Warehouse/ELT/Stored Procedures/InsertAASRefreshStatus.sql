CREATE PROC [ELT].[InsertAASRefreshStatus] @JSONDATA [varchar](8000),@Status [varchar](25) AS 

update ELT.ImportJsonAAS set [status] = @Status