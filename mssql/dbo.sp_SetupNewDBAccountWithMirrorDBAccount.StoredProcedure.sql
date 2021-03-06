USE [dbamgnt]
GO
/****** Object:  StoredProcedure [dbo].[sp_SetupNewDBAccountWithMirrorDBAccount]    Script Date: 9/5/2017 6:13:35 AM ******/
DROP PROCEDURE [dbo].[sp_SetupNewDBAccountWithMirrorDBAccount]
GO
/****** Object:  StoredProcedure [dbo].[sp_SetupNewDBAccountWithMirrorDBAccount]    Script Date: 9/5/2017 6:13:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_SetupNewDBAccountWithMirrorDBAccount]
	@MirrorAccount varchar(255)
	,@NewUserAccount varchar(255)
	,@IsNewUserAccountWindowsLogin INT
	,@IsNewUserAccountWindowsGroup INT = -1
	,@OutputTSQLCode CHAR(1) = 'N'
	,@MirrorAccountLDAPName varchar(255) 
	,@NewUserAccountLDAPName varchar(255)
AS
-- ***********************************************************************
-- Stored Procedure Name:	[dbo].[sp_SetupNewDBAccountWithMirrorDBAccount]
-- Date Created:			2012-12-27
-- By: 						Thomas Liddle
--
-- Purpose:					This proc will produce a SQL Server Script that
--							can be executed in a separate query window
--							to create a new account
--
--							Useful Information
--							@MirrorAccountLDAP Name Example = LDAP://dc=domain,dc=com
--							@NewUserAccountLDAPName Name Example = LDAP://dc=domain,dc=com
--
--
--							This procedure will NOT include Server Roles
--							
--							Example:
--								Setup a New Windows User
--									EXEC [Audit].[spr_SetupNewDBAccount]
--										@MirrorAccount = 'DOMAIN\ExistingAccount'
--										,@NewUserAccount = 'DOMAIN\<UserName>'
--										,@IsNewUserAccountWindowsLogin = 1
--										,@OutputTSQLCode = 'N'
--
--
--								Setup a SQL Login
--									EXEC [Audit].[spr_SetupNewDBAccount]
--										@MirrorAccount = '<ExistingSQLLogin>'
--										,@NewUserAccount = '<NewUserAccount>'
--										,@IsNewUserAccountWindowsLogin = 0
-- 
-- 
-- Updated:
-- By:				On:			Reason:
-- Thomas Liddle	2012-12-27	Created
-- Thomas Liddle	2013-01-08	Updated Control Flow Logic
-- Thomas Liddle	2013-01-10	Added parm @IsNewUserAccountWindowsLogin
-- Thomas Liddle	2013-01-11	Update individual Permissions query to 
--								include Grant/Deny permission
-- Thomas Liddle	2013-01-11	Test Source Control
-- Thomas Liddle	2013-09-20	Added Code for Server Based Permissions
-- Thomas Liddle	2013-09-23  Added code to create server login and permission
--								database automatically
-- ***********************************************************************
SET NOCOUNT ON
DECLARE @IsMirrorSQLLogin INT
DECLARE @IsMirrorWinLoginOnSQLServer INT 
DECLARE @IsMirrorWinLoginInAD INT
DECLARE @MirrorAccountType varchar(255)
DECLARE @sqlcmd varchar(4096)
DECLARE @PermissionPath varchar(255)
DECLARE @result int

SET @IsMirrorWinLoginOnSQLServer = 0
SET @IsMirrorSQLLogin = 0
SET @IsMirrorWinLoginInAD = 0


--Check to make sure the executor specified the correct parms
--for this stored proc
IF @IsNewUserAccountWindowsLogin NOT IN (0,1)
	BEGIN
		RAISERROR('An incorrect parameter was specified for @IsNewUserAccountWindowsLogin.  Values can be 0 (New Account IS NOT a Windows Login) OR 1 (New Account IS a Windows Login).',16,1)
		RETURN
	END


--CHECK TO MAKE SURE THE New Account Specified is a Windows Account
--if the user specfied 1 for the parm @IsNewUserAccountWindowsLogin

IF @IsNewUserAccountWindowsLogin = 1
BEGIN
		DECLARE @ADNewAccount TABLE(
			sAMAccountName varchar(128))

		SET @sqlcmd = 'select  * from  openquery(adsi, ''select  sAMAccountName from    ''''' + @NewUserAccountLDAPName + ''''' WHERE objectCategory = ''''Person'''' and objectClass = ''''user'''' and sAMAccountName = ''''' + REPLACE(@NewUserAccount,SUBSTRING(@NewUserAccount,1,CHARINDEX('\',@NewUserAccount,1)),'') + ''''''')'
		INSERT INTO @ADNewAccount
			EXEC (@sqlcmd)
			
		IF (SELECT COUNT(*) FROM @ADNewAccount) = 0
			BEGIN
				RAISERROR('The New User specified is not in Active Directory.  Please check the name and try again.',16,1)
				RETURN
			END
END


--CHECK TO MAKE SURE THE MirrorAccount Exists on the SQL Server
IF (SELECT COUNT(name) from sys.server_principals WHERE name = @MirrorAccount) = 1
	BEGIN		
		
		SELECT @MirrorAccountType = type_desc FROM sys.server_principals WHERE name = @MirrorAccount
		
		IF @MirrorAccountType = 'WINDOWS_LOGIN'
			BEGIN
				SET @IsMirrorWinLoginOnSQLServer = 1
			END
			
		IF @MirrorAccountType = 'SQL_LOGIN'
			BEGIN
				SET @IsMirrorSQLLogin = 1
			END
		
		IF @MirrorAccountType IN ('WINDOWS_GROUP','SERVER_ROLE','CERTIFICATE_MAPPED_LOGIN','ASYMMETRIC_KEY_MAPPED_LOGIN')
			BEGIN
				RAISERROR('The Mirror Account specified can not be used by this procedure.  Please specify a SQL_LOGIN or WINDOWS_LOGIN.',16,1)
				RETURN
			END
	END	

IF @IsMirrorWinLoginOnSQLServer = 0 AND @IsMirrorSQLLogin = 0
	BEGIN
		-- Check if the MirrorAccount is in Active Directory and assume the mirror account
		-- only accesses this SQL Server via a Windows Group
		-- We will get a list of Windows Groups that the Mirror account is apart of
		-- and exist on this SQL Server.	
		DECLARE @ADRetVal TABLE(
			sAMAccountName varchar(128))

		SET @sqlcmd = 'select  * from  openquery(adsi, ''select  sAMAccountName from    ''''' + @MirrorAccountLDAPName + ''''' where   objectCategory = ''''Person'''' and objectClass = ''''user'''' and sAMAccountName = ''''' + REPLACE(@NewUserAccount,SUBSTRING(@NewUserAccount,1,CHARINDEX('\',@NewUserAccount,1)),'') + ''''''')'
		INSERT INTO @ADRetVal
			EXEC (@sqlcmd)
			
		SELECT @IsMirrorWinLoginInAD = COUNT(*) FROM @ADRetVal
		
		IF @IsMirrorWinLoginInAD = 1
			BEGIN
						DECLARE @WindowsGroupMembers TABLE(
						AccountName varchar(255)
						,Type varchar(255)
						,privilege varchar(255)
						,MappedLoginName varchar(255)
						,PermissionPath varchar(255))
								
								INSERT INTO @WindowsGroupMembers
									EXEC master..xp_logininfo @MirrorAccount, 'all'
								
								IF (SELECT COUNT(AccountName) FROM @WindowsGroupMembers) = 0
									BEGIN
										INSERT INTO @WindowsGroupMembers (AccountName)
											SELECT @NewUserAccount
								END
								
						PRINT '--USER NEEDS TO BE APART OF THE FOLLOWING WINDOWS GROUP(s):'
						PRINT '--Move the sidebar to WINTEL OR IF THIS IS PART OF AN ITG'
						PRINT '--EMAIL WINTEL Group with ITG number, USERID, AND GROUP NAME(s) BELOW'
						
						DECLARE grpmem_cursor CURSOR
						FOR
						SELECT PermissionPath FROM @WindowsGroupMembers WHERE PermissionPath IS NOT NULL
						OPEN grpmem_cursor
						fetch next from grpmem_cursor INTO @PermissionPath
						WHILE (@@FETCH_STATUS <> -1)
						BEGIN
						  IF (@@FETCH_STATUS <> -2)
							BEGIN
								PRINT '--   ' + @PermissionPath
							END
							FETCH NEXT FROM grpmem_cursor INTO @PermissionPath
						END
						CLOSE grpmem_cursor
						DEALLOCATE grpmem_cursor
						PRINT ''
						PRINT ''
						
						--BECAUSE THE MIRROR ACCOUNT ONLY HAS ACCESS TO THE SERVER VIA A WINDOWS GROUP
						--THE MESSAGE IS GIVEN TO THE USER RUNNING THE PROCEDURE A LIST OF WINDOWS GROUP
						--THE NEW ACCOUNT NEEDS ACCESS TOO.  AFTER THIS WE DO NOT EXECUTE THE REST OF THIS
						--SCRIPT
						RETURN
			END
	END

IF @IsMirrorWinLoginOnSQLServer = 0 AND @IsMirrorWinLoginInAD = 0 AND @IsMirrorSQLLogin = 0
	BEGIN
		RAISERROR('The mirror account specified does not exist on this SQL Server OR Active Directory.  Please check the name and try again.',16,1)
		RETURN
	END	

IF @MirrorAccountType IN ('WINDOWS_LOGIN') AND @IsNewUserAccountWindowsLogin = 1
	BEGIN
		--FIND OUT WHAT WINDOWS GROUPS THE USER IS APART OF THAT HAVE ACCESS TO THIS SQL SERVER
		DECLARE @WindowsGroupMembers1 TABLE(
			AccountName varchar(255)
			,Type varchar(255)
			,privilege varchar(255)
			,MappedLoginName varchar(255)
			,PermissionPath varchar(255))
					
					INSERT INTO @WindowsGroupMembers1
						EXEC master..xp_logininfo @MirrorAccount, 'all'
					
					IF (SELECT COUNT(AccountName) FROM @WindowsGroupMembers1) = 0
						BEGIN
							INSERT INTO @WindowsGroupMembers1 (AccountName)
								SELECT @NewUserAccount
					END

			IF (SELECT COUNT(PermissionPath) FROM @WindowsGroupMembers1 WHERE PermissionPath IS NOT NULL) <> 0
			BEGIN
				PRINT '--THE NEW USER NEEDS TO BE APART OF THE FOLLOWING WINDOWS GROUP(s):'
				PRINT ''
				PRINT '--Move the sidebar to WINTEL OR IF THIS IS PART OF AN ITG'
				PRINT '--EMAIL WINTEL Group with ITG number, USERID, AND GROUP NAME(s) BELOW'			

				DECLARE grpmem_cursor CURSOR
				FOR
				SELECT PermissionPath FROM @WindowsGroupMembers1 WHERE PermissionPath IS NOT NULL
				OPEN grpmem_cursor

				fetch next from grpmem_cursor INTO @PermissionPath
				WHILE (@@FETCH_STATUS <> -1)
				BEGIN
				  IF (@@FETCH_STATUS <> -2)
					BEGIN
						PRINT '--   ' + @PermissionPath
					END
					FETCH NEXT FROM grpmem_cursor INTO @PermissionPath
				END
				CLOSE grpmem_cursor
				DEALLOCATE grpmem_cursor
				PRINT ''
				PRINT ''	
			
			END
	END

IF @IsNewUserAccountWindowsLogin = 1
	BEGIN
		-- SET variable to create user
			SET @sqlcmd = '-- CREATE SERVER LOGIN for [' + @NewUserAccount + ']
							USE [master]
							IF  NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = ''' + @NewUserAccount + ''')
							CREATE LOGIN [' + @NewUserAccount + '] FROM WINDOWS;'
	
	
		IF @OutputTSQLCode = 'Y'
			BEGIN	
				PRINT @sqlcmd
			END
		
		IF @OutputTSQLCode = 'N'
			BEGIN
			 EXEC(@sqlcmd)
			END
	END


IF @IsNewUserAccountWindowsLogin = 0
	BEGIN
		SET @sqlcmd = '-- CREATE SERVER LOGIN for [' + @NewUserAccount + ']
						USE [master]
						IF  NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = ''' + @NewUserAccount + ''')
						CREATE LOGIN [' + @NewUserAccount + '] WITH PASSWORD=N''dbapwd!123'' MUST_CHANGE, DEFAULT_DATABASE=[master], CHECK_EXPIRATION=ON, CHECK_POLICY=ON'	
		
		
		IF @OutputTSQLCode = 'Y'
			BEGIN	
				PRINT @sqlcmd
			END
		
		IF @OutputTSQLCode = 'N'
			BEGIN
			 EXEC(@sqlcmd)
			END			
	END

-- CREATE THE DATABASE USER IN EACH DATABASE THE MIRROR ACCOUNT HAS ACCESS TO
DECLARE db_cursor CURSOR
FOR
	SELECT name from sys.databases WHERE name NOT IN ('tempdb','model','msdb','master')
	AND state = 0
	ORDER BY name ASC
OPEN db_cursor
DECLARE @name sysname
fetch next from db_cursor INTO @name
WHILE (@@FETCH_STATUS <> -1)
BEGIN
  IF (@@FETCH_STATUS <> -2)
    BEGIN		
		IF @OutputTSQLCode = 'Y'
			BEGIN
				SET @sqlcmd = 'IF (SELECT COUNT(name) FROM [' + @name + '].sys.database_principals WHERE name = ''' + @MirrorAccount + ''') = 1 BEGIN PRINT ''USE [' + @name + ']''  + CHAR(13) + CHAR(10) + ''GO'' + CHAR(13) + CHAR(10) + ''IF  NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = ''''' + @NewUserAccount + ''''')'' + CHAR(13) + CHAR(10) +  ''     CREATE USER [' + @NewUserAccount + '] FOR LOGIN [' + @NewUserAccount + ']'' + CHAR(13) + CHAR(10) + ''GO'' + CHAR(13) + CHAR(10) END'	
				EXEC(@sqlcmd)
			END
		
		IF @OutputTSQLCode = 'N'
			BEGIN
				SET @sqlcmd = 'USE [' + @name + ']
								IF (SELECT COUNT(name) FROM [' + @name + '].sys.database_principals WHERE name = ''' + @MirrorAccount + ''') = 1 
								BEGIN 
									PRINT ''STATUS:  CREATE DATABASE USER [''''' + @NewUserAccount + '''''] IN DATABASE [''''' + @name + '''''] USING MIRROR ACCOUNT [''''' + @MirrorAccount + ''''']''
									IF  NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = ''' + @NewUserAccount + ''')
									CREATE USER [' + @NewUserAccount + '] FOR LOGIN [' + @NewUserAccount + '] WITH DEFAULT_SCHEMA = [dbo] 
								END'
				EXEC(@sqlcmd)
			END		
		
    END
    FETCH NEXT FROM db_cursor INTO @name
END
CLOSE db_cursor
DEALLOCATE db_cursor 



-- NOW LOOK FOR THE ROLES THE MIRROR ACCOUNT HAS ACCESS TO
DECLARE dbrole_cursor CURSOR
FOR
	SELECT name from sys.databases WHERE name NOT IN ('tempdb','model','msdb','master')
	AND state = 0
	ORDER BY name ASC
OPEN dbrole_cursor
DECLARE @roledbname sysname
DECLARE @tbRoles TABLE (
	RoleName varchar(128))
fetch next from dbrole_cursor INTO @roledbname
WHILE (@@FETCH_STATUS <> -1)
BEGIN
  IF (@@FETCH_STATUS <> -2)
    BEGIN
		SET @sqlcmd = 'select dbp.name from [' + @roledbname + '].sys.database_role_members rm inner join [' + @roledbname + '].sys.database_principals dbp on rm.role_principal_id = dbp.principal_id inner join [' + @roledbname + '].sys.database_principals dbp1	on rm.member_principal_id = dbp1.principal_id where dbp1.name = ''' + @MirrorAccount + ''''
		INSERT INTO @tbRoles
			EXEC(@sqlcmd)
		
		
		DECLARE sptdbrole_cursor CURSOR
			FOR
			  SELECT RoleName FROM @tbRoles
			OPEN sptdbrole_cursor
			DECLARE @rolename varchar(128)
			fetch next from sptdbrole_cursor INTO @rolename
			WHILE (@@FETCH_STATUS <> -1)
			BEGIN
			  IF (@@FETCH_STATUS <> -2)
				BEGIN
						SET @sqlcmd = '
									   USE [' + @roledbname + '] 
									   PRINT ''STATUS:  ADD DATABASE USER [''''' + @NewUserAccount + '''''] IN DATABASE [''''' + @roledbname + '''''] TO DATABASE ROLE [''''' + @ROLENAME + '''''] USING MIRROR ACCOUNT [''''' + @MirrorAccount + ''''']''
									   EXEC sp_addrolemember @rolename = ''' + @rolename + ''', @membername=''' + @NewUserAccount + ''''
				
						IF @OutputTSQLCode = 'Y'
							BEGIN	
								PRINT @sqlcmd
							END
						
						IF @OutputTSQLCode = 'N'
							BEGIN
								EXEC(@sqlcmd)
							END	
				END
				FETCH NEXT FROM sptdbrole_cursor INTO @rolename
			END
			CLOSE sptdbrole_cursor
			DEALLOCATE sptdbrole_cursor
	
    END
    DELETE FROM @tbRoles
    FETCH NEXT FROM dbrole_cursor INTO @roledbname
END
CLOSE dbrole_cursor
DEALLOCATE dbrole_cursor 


DECLARE @DBPermissions TABLE (
	cSchema varchar(255)
	,cObject varchar(255)
	,cGrantee varchar(255)
	,cGrantor varchar(255)
	,cProtectType varchar(255)
	,cAction varchar(255)
	,cColumn varchar(255))

DECLARE dbperm_cursor CURSOR
FOR
	SELECT name from sys.databases WHERE name NOT IN ('tempdb','model','msdb','master')
	AND state = 0
	ORDER BY name asc
OPEN dbperm_cursor
DECLARE @perdbname varchar(255)
fetch next from dbperm_cursor INTO @perdbname
WHILE (@@FETCH_STATUS <> -1)
BEGIN
  IF (@@FETCH_STATUS <> -2)
    BEGIN
		
		SET @sqlcmd = 'EXEC [' + @perdbname + '].dbo.sp_helprotect'
		INSERT INTO @DBPermissions
			EXEC(@sqlcmd)
		
		update @DBPermissions
		set cColumn = NULL
		WHERE cColumn = '.'	
		
		DECLARE dbperm1_cursor CURSOR
			FOR
			SELECT 
				cSchema
				,cObject
				,cAction
				,cGrantee
				,cProtectType
			FROM @DBPermissions
			WHERE cSchema NOT IN ('.','sys')
			AND cGrantee NOT IN ('public','guest')
			AND cGrantee = @MirrorAccount
			OPEN dbperm1_cursor
			DECLARE @cSchema varchar(255)
			DECLARE @cObject varchar(255)
			DECLARE @cAction varchar(255)
			DECLARE @cGrantee varchar(255)
			DECLARE @cProtectType varchar(255)
			fetch next from dbperm1_cursor INTO @cSchema,@cObject,@cAction,@cGrantee,@cProtectType
			WHILE (@@FETCH_STATUS <> -1)
			BEGIN
			  IF (@@FETCH_STATUS <> -2)
				BEGIN
					SET @sqlcmd = 'USE [' + @perdbname + '] ' + 
									REPLACE(UPPER(@cProtectType),' ', '') + ' ' + UPPER(@cAction) + ' ON [' + @cSchema + '].[' + @cObject + '] TO [' + @NewUserAccount + '] '
					
						IF @OutputTSQLCode = 'Y'
							BEGIN	
								PRINT @sqlcmd
							END
						
						IF @OutputTSQLCode = 'N'
							BEGIN
								--PRINT 'STATUS:  ' + REPLACE(UPPER(@cProtectType),' ', '') + ' DATABASE USER [' + @NewUserAccount + '] IN DATABASE [' + @name + '] ON [' + @cSchema + '].[' + @cObject + '] USING MIRROR ACCOUNT [' + @MirrorAccount + ']'
								PRINT 'N/A'
								--EXEC(@sqlcmd)
							END	
				END
				FETCH NEXT FROM dbperm1_cursor INTO @cSchema,@cObject,@cAction,@cGrantee,@cProtectType
			END
			CLOSE dbperm1_cursor
			DEALLOCATE dbperm1_cursor
		
    END
    DELETE FROM @DBPermissions
    FETCH NEXT FROM dbperm_cursor INTO @perdbname
END
CLOSE dbperm_cursor
DEALLOCATE dbperm_cursor

DECLARE srvperm_cursor CURSOR
FOR
	SELECT 
		state_desc
		,permission_name 
	FROM sys.server_permissions servperm inner join sys.server_principals servprinc
	on servperm.grantee_principal_id = servprinc.principal_id
	where servprinc.name=@MirrorAccount
OPEN srvperm_cursor
DECLARE @PermissionType sysname
DECLARE @PermissionName sysname
fetch next from srvperm_cursor INTO @PermissionType,@PermissionName
WHILE (@@FETCH_STATUS <> -1)
BEGIN
  IF (@@FETCH_STATUS <> -2)
    BEGIN
	SET @sqlcmd = 'USE [master] ' +
					'PRINT ''STATUS:  [' + @PermissionType + '] SERVER LOGIN [' + @NewUserAccount + '] SERVER PERMISSION [' + @PermissionName + '] USING MIRROR ACCOUNT [' + @MirrorAccount +']'''
				  +  ' ' +@PermissionType + ' ' + @PermissionName + ' TO [' + @NewUserAccount + ']'

			IF @OutputTSQLCode = 'Y'
			BEGIN	
				PRINT @sqlcmd
			END
			
			IF @OutputTSQLCode = 'N'
				BEGIN
					EXEC(@sqlcmd)
				END	
    END
    FETCH NEXT FROM srvperm_cursor INTO @PermissionType,@PermissionName
END
CLOSE srvperm_cursor
DEALLOCATE srvperm_cursor




GO
