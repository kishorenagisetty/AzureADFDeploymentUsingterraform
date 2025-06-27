--get current SQL server name
--declare @ServerName varchar(max) = (select convert(Varchar(20),SERVERPROPERTY('ServerName'),101));
--declare @DBName varchar(max) = (select DB_NAME());
--declare @USER varchar(max) = (select case when @Servername = 'ukmaxbitestsql01' then 'UKMAXBITESTDF01' when @Servername = 'ukmaxbiprodsql01' then 'UKMAXBIPRODDF01' end );
--declare @SQLString nvarchar(max);

--set @SQLString = 'use ' + @DBName + ';'
--EXEC sp_executesql @SQLString;
--set @SQLString = '';

--CREATE USER [ssis_user] --( this is within the DB itself)
--FROM LOGIN [ssis_user]
--WITH DEFAULT_SCHEMA=dbo;


--grant connect to [ssis_user]
--grant execute to [ssis_user]
--grant alter ON SCHEMA :: LZ to [ssis_user]
--Grant control on schema::dbo to ssis_user

--EXEC sp_addrolemember 'db_datareader', 'ssis_user';
--EXEC sp_addrolemember 'db_datawriter', 'ssis_user';

--set @SQLString =

--'GRANT control ON SCHEMA :: LZ TO ' + @USER +';  
--GRANT Alter on SCHEMA :: LZ TO ' + @USER +'; 
--Grant create table to ' + @USER +';
--Grant execute to ' + @USER +';
--Grant select to ' + @USER +';
--Grant insert to ' + @USER +' 
--Grant update to ' + @USER +';' 

--EXEC sp_executesql @SQLString;
--set @SQLString = '';

--EXEC sp_addrolemember 'db_datareader', 'UK-BI-DW-Developer'; 




