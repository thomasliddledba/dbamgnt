USE [dbamgnt]
GO
EXEC sys.sp_dropextendedproperty @name=N'Source' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'PROCEDURE',@level1name=N'sp_UpdateSQLJobOwner'

GO
EXEC sys.sp_dropextendedproperty @name=N'Description' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'PROCEDURE',@level1name=N'sp_UpdateSQLJobOwner'

GO
EXEC sys.sp_dropextendedproperty @name=N'Author' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'PROCEDURE',@level1name=N'sp_UpdateSQLJobOwner'

GO
/****** Object:  StoredProcedure [dbo].[sp_UpdateSQLJobOwner]    Script Date: 9/5/2017 6:13:35 AM ******/
DROP PROCEDURE [dbo].[sp_UpdateSQLJobOwner]
GO
/****** Object:  StoredProcedure [dbo].[sp_UpdateSQLJobOwner]    Script Date: 9/5/2017 6:13:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_UpdateSQLJobOwner]
	@DoNotRun CHAR(1) = 'N'
AS
-- ***********************************************************************
-- Stored Procedure Name:	[dbo].[sp_UpdateSQLJobOwner]
-- Date Created:			2011-12-07
-- By: 						Thomas Liddle
--
-- Purpose:			Update All SQL Jobs with SQL Agent Service Account
--
-- Input Parms:				@DoNotRun
--							Y = Yes
--							N = No
--  
-- Updated:
-- By:				On:			Reason:
-- Thomas Liddle	2011-12-07	Created
-- ***********************************************************************
IF @DoNotRun = 'Y'
	BEGIN
		PRINT 'The @DoNotRun parm was specified with ''Y''.  Job will quit with success'
		RETURN
	END

DECLARE @InstanceName varchar(128)
DECLARE @KeyPath varchar(255)
DECLARE @ServiceaccountName varchar(250) 

SELECT @InstanceName = CONVERT(VARCHAR(255),SERVERPROPERTY('InstanceName')) 

IF @InstanceName IS NULL
	BEGIN
		SET @InstanceName = 'MSSQLSERVER'
		SET @KeyPath = 'SYSTEM\CurrentControlSet\Services\SQLSERVERAGENT'
	END
ELSE
	BEGIN
		SET @KeyPath = 'SYSTEM\CurrentControlSet\Services\SQLAgent$' + @InstanceName
	END

EXECUTE master.dbo.xp_instance_regread 
N'HKEY_LOCAL_MACHINE', 
@KeyPath, 
N'ObjectName', 
@ServiceAccountName OUTPUT, 
N'no_output'
  
IF @ServiceAccountName IN ('Local System'
							,'Network Service'
							,'NT AUTHORITY\NETWORK SERVICE'
							,'NT AUTHORITY\LOCAL SERVICE')
	BEGIN
		RAISERROR('The SQL Server Agent Account is not set to a Windows Domain Account.',16,1)
		RETURN
	END


-- NEED TO ADD THE SQL AGENT ACCOUNT AS A WINDOWS_LOGIN SO THAT SPR_GETJOBSTATUS WORKS
-- CORRECTLY.
	
IF (SELECT COUNT(*) FROM sys.server_principals WHERE name = @ServiceaccountName) = 0
BEGIN
	DECLARE @sqlcmd varchar(2048)
	
	SET @sqlcmd = 'CREATE LOGIN [' + @ServiceaccountName + '] FROM WINDOWS WITH DEFAULT_DATABASE=[master]'
	EXEC (@sqlcmd)
	SET @sqlcmd = 'EXEC master..sp_addsrvrolemember @loginame = N''' + @ServiceAccountName + ''', @rolename = N''sysadmin'''
	EXEC (@sqlcmd)
END


DECLARE jobnames_cursor CURSOR
FOR
	SELECT sysjob.name FROM msdb.dbo.sysjobs sysjob 
		INNER JOIN msdb.dbo.syscategories syscat
			ON sysjob.category_id = syscat.category_id
	WHERE syscat.name NOT IN ('Report Server')
	ORDER BY name
OPEN jobnames_cursor
DECLARE @jobnames sysname
fetch next from jobnames_cursor INTO @jobnames
WHILE (@@FETCH_STATUS <> -1)
BEGIN
  IF (@@FETCH_STATUS <> -2)
    BEGIN
		EXEC msdb.dbo.sp_update_job 
				@job_name=@jobnames, 
				@owner_login_name=@ServiceAccountName
    END
    FETCH NEXT FROM jobnames_cursor INTO @jobnames
	
END
CLOSE jobnames_cursor
DEALLOCATE jobnames_cursor



GO
EXEC sys.sp_addextendedproperty @name=N'Author', @value=N'Thomas Liddle' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'PROCEDURE',@level1name=N'sp_UpdateSQLJobOwner'
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'This procedure will change the owner of all SQL Server Agent Jobs to the SQL Server Agent account.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'PROCEDURE',@level1name=N'sp_UpdateSQLJobOwner'
GO
EXEC sys.sp_addextendedproperty @name=N'Source', @value=N'http://www.thomasliddledba.com' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'PROCEDURE',@level1name=N'sp_UpdateSQLJobOwner'
GO
