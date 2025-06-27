
--GO
--EXECUTE sp_addrolemember @rolename = N'db_owner', @membername = N'UKMAXBIPRODDF01';

--GO
--EXECUTE sp_addrolemember @rolename = N'db_owner', @membername = N'UKMAXBITESTDF01';

--GO
--EXECUTE sp_addrolemember @rolename = N'db_datareader', @membername = N'UK-BI-DW-Developer';


--GO
--EXECUTE sp_addrolemember @rolename = N'db_datawriter', @membername = N'UK-BI-DW-Developer';


--GO
--EXECUTE sp_addrolemember @rolename = N'db_datareader', @membername = N'UK-BI-User';


--GO
--EXECUTE sp_addrolemember @rolename = N'db_datareader', @membername = N'UK-BI-ReportingDeveloper';


--GO



--GO


--GO
--EXECUTE sp_addrolemember @rolename = N'db_owner', @membername = N'UKMAXBITESTDTBRKSDF01';