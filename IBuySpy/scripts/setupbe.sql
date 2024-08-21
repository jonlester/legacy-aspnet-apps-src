USE [master]
GO

create login [NT Authority\NETWORK Service] from windows;
exec sp_addsrvrolemember 'NT AUTHORITY\Network Service' , 'sysadmin';
GO

EXEC sys.sp_addsrvrolemember @loginame = 'NT AUTHORITY\NETWORK SERVICE', @rolename = N'dbcreator'
GO


CREATE LOGIN [$(DOMAIN_NAME)\$(MACHINE_NAME)$] FROM WINDOWS WITH
DEFAULT_LANGUAGE = [us_english]
GO

EXEC sys.sp_addsrvrolemember @loginame = '$(DOMAIN_NAME)\$(MACHINE_NAME)$', @rolename = N'dbcreator'
GO

CREATE DATABASE [Store]
GO

USE [Store]
CREATE USER [$(DOMAIN_NAME)\$(MACHINE_NAME)$] FOR LOGIN [$(DOMAIN_NAME)\$(MACHINE_NAME)$]
EXEC sys.sp_addrolemember @rolename = N'db_owner', @membername = '$(DOMAIN_NAME)\$(MACHINE_NAME)$'
GO