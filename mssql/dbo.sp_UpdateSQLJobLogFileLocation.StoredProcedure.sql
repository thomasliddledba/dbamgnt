USE [dbamgnt]
GO
EXEC sys.sp_dropextendedproperty @name=N'Source' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'PROCEDURE',@level1name=N'sp_UpdateSQLJobLogFileLocation'

GO
EXEC sys.sp_dropextendedproperty @name=N'Description' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'PROCEDURE',@level1name=N'sp_UpdateSQLJobLogFileLocation'

GO
EXEC sys.sp_dropextendedproperty @name=N'Author' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'PROCEDURE',@level1name=N'sp_UpdateSQLJobLogFileLocation'

GO
/****** Object:  StoredProcedure [dbo].[sp_UpdateSQLJobLogFileLocation]    Script Date: 9/5/2017 6:13:35 AM ******/
DROP PROCEDURE [dbo].[sp_UpdateSQLJobLogFileLocation]
GO
/****** Object:  StoredProcedure [dbo].[sp_UpdateSQLJobLogFileLocation]    Script Date: 9/5/2017 6:13:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_UpdateSQLJobLogFileLocation]
	@DoNotRun CHAR(1) = 'N'
AS
-- ***********************************************************************
-- Stored Procedure Name:	[dbo].[sp_UpdateSQLJobLogFileLocation]
-- Date Created:			2011-12-07
-- By: 						Thomas Liddle
--
-- Purpose:					Updates job log file path
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
		PRINT CONVERT(varchar(255), GETDATE(), 126) + '	ERROR	The @DoNotRun parm was specified with ''Y''.  Job will quit with success'
		RETURN
	END

DECLARE @InstanceName varchar(128)
DECLARE @KeyPath varchar(255)
DECLARE @InstanceNameDirectoryName varchar(1024)
DECLARE @SQLAgentLogPath varchar(2048) 

SELECT @InstanceName = CONVERT(VARCHAR(255),SERVERPROPERTY('InstanceName'))

IF @InstanceName IS NULL
	BEGIN
		SET @InstanceName = 'MSSQLSERVER'
	END 
SET @KeyPath = 'SOFTWARE\Microsoft\Microsoft SQL Server\Instance Names\SQL'

EXECUTE master.dbo.xp_regread
N'HKEY_LOCAL_MACHINE', 
@KeyPath, 
@InstanceName, 
@InstanceNameDirectoryName OUTPUT, 
N'no_output'

SET @KeyPath = 'SOFTWARE\Microsoft\Microsoft SQL Server\' + @InstanceNameDirectoryName + '\SQLServerAgent'
EXECUTE master.dbo.xp_regread
N'HKEY_LOCAL_MACHINE', 
@KeyPath, 
'ErrorLogFile', 
@InstanceNameDirectoryName OUTPUT,
N'no_output'

SELECT @SQLAgentLogPath = REVERSE(SUBSTRING(REVERSE(@InstanceNameDirectoryName),CHARINDEX('\',REVERSE(@InstanceNameDirectoryName)),LEN(@InstanceNameDirectoryName)))
PRINT CONVERT(varchar(255), GETDATE(), 126) + '	STATUS	Error File Location:  ' + @SQLAgentLogPath

IF @SQLAgentLogPath IS NULL
	BEGIN
		RAISERROR('The registry key for this SQL Server is NULL.  Please update',16,1)
	END

DECLARE jobnames_cursor CURSOR
FOR
	SELECT 
		j.name
		,js.step_name 
		,js.step_id
		,SUBSTRING(@SQLAgentLogPath + UPPER('JOB-' + REPLACE(j.name,' ', '') + '_STEP-' + REPLACE(js.step_name,' ','')),1,124) + '.log' as 'outputfile'
	FROM msdb..sysjobsteps js inner join msdb..sysjobs j
		on j.job_id = js.job_id
	where js.subsystem NOT IN ('ActiveScripting','Distribution','Merge','QueueReader','Snapshot','LogReader')
OPEN jobnames_cursor
DECLARE @jobnames sysname
DECLARE @jobstepname sysname
DECLARE @jobstepid sysname
DECLARE @outputfile sysname
fetch next from jobnames_cursor INTO @jobnames,@jobstepname,@jobstepid,@outputfile
WHILE (@@FETCH_STATUS <> -1)
BEGIN
  IF (@@FETCH_STATUS <> -2)
    BEGIN
		PRINT ''
		PRINT '******************************************************************************'
		PRINT 'Update Job ''' + @jobnames + ''' and Job Step ''' + @JobStepName + ''''
		PRINT 'Output File Name:  ' + @outputfile
		PRINT '******************************************************************************'
		PRINT ''
		EXEC msdb..sp_update_jobstep
			@job_name = @jobnames
			,@step_id = @jobstepid
			,@output_file_name = @outputfile
			,@flags = 2
    END
    FETCH NEXT FROM jobnames_cursor INTO @jobnames,@jobstepname,@jobstepid,@outputfile
END
CLOSE jobnames_cursor
DEALLOCATE jobnames_cursor



GO
EXEC sys.sp_addextendedproperty @name=N'Author', @value=N'Thomas Liddle' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'PROCEDURE',@level1name=N'sp_UpdateSQLJobLogFileLocation'
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'This procedure will change the output file location to the same path as the SQL Server Agent ERROR Log.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'PROCEDURE',@level1name=N'sp_UpdateSQLJobLogFileLocation'
GO
EXEC sys.sp_addextendedproperty @name=N'Source', @value=N'http://www.thomasliddledba.com' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'PROCEDURE',@level1name=N'sp_UpdateSQLJobLogFileLocation'
GO
