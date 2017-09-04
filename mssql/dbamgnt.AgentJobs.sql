SET NOCOUNT ON

DECLARE @CreateJobs nvarchar(max)
DECLARE @BackupDirectory nvarchar(max)
DECLARE @CleanupTime int
DECLARE @OutputFileDirectory nvarchar(max)
DECLARE @LogToTable nvarchar(max)
DECLARE @Version numeric(18,10)
DECLARE @Error int
DECLARE @DatabaseName varchar(max)

SET @BackupDirectory     = (SELECT Value FROM dbamgnt.dbo.DefaultParms where parm = 'BackupDirectory') -- Specify the backup root directory.
SET @CleanupTime         = NULL         -- Time in hours, after which backup files are deleted. If no time is specified, then no backup files are deleted.
SET @OutputFileDirectory = NULL         -- Specify the output file directory. If no directory is specified, then the SQL Server error log directory is used.
SET @LogToTable          = (SELECT Value FROM dbamgnt.dbo.DefaultParms where parm = 'LogToTable')          -- Log commands to a table.
SET @DatabaseName = 'dbamgnt'


IF (SELECT SERVERPROPERTY('EngineEdition')) <> 4
BEGIN

  DECLARE @TokenServer nvarchar(max)
  DECLARE @TokenJobID nvarchar(max)
  DECLARE @TokenStepID nvarchar(max)
  DECLARE @TokenDate nvarchar(max)
  DECLARE @TokenTime nvarchar(max)
  DECLARE @TokenLogDirectory nvarchar(max)

  DECLARE @JobDescription nvarchar(max)
  DECLARE @JobCategory nvarchar(max)
  DECLARE @JobOwner nvarchar(max)

  DECLARE @JobName01 nvarchar(max)
  DECLARE @JobName02 nvarchar(max)
  DECLARE @JobName03 nvarchar(max)
  DECLARE @JobName04 nvarchar(max)
  DECLARE @JobName05 nvarchar(max)
  DECLARE @JobName06 nvarchar(max)
  DECLARE @JobName07 nvarchar(max)
  DECLARE @JobName08 nvarchar(max)
  DECLARE @JobName09 nvarchar(max)
  DECLARE @JobName10 nvarchar(max)
  DECLARE @JobName11 nvarchar(max)

  DECLARE @JobCommand01 nvarchar(max)
  DECLARE @JobCommand02 nvarchar(max)
  DECLARE @JobCommand03 nvarchar(max)
  DECLARE @JobCommand04 nvarchar(max)
  DECLARE @JobCommand05 nvarchar(max)
  DECLARE @JobCommand06 nvarchar(max)
  DECLARE @JobCommand07 nvarchar(max)
  DECLARE @JobCommand08 nvarchar(max)
  DECLARE @JobCommand09 nvarchar(max)
  DECLARE @JobCommand10 nvarchar(max)
  DECLARE @JobCommand11 nvarchar(max)

  DECLARE @OutputFile01 nvarchar(max)
  DECLARE @OutputFile02 nvarchar(max)
  DECLARE @OutputFile03 nvarchar(max)
  DECLARE @OutputFile04 nvarchar(max)
  DECLARE @OutputFile05 nvarchar(max)
  DECLARE @OutputFile06 nvarchar(max)
  DECLARE @OutputFile07 nvarchar(max)
  DECLARE @OutputFile08 nvarchar(max)
  DECLARE @OutputFile09 nvarchar(max)
  DECLARE @OutputFile10 nvarchar(max)
  DECLARE @OutputFile11 nvarchar(max)

  SET @Version = CAST(LEFT(CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max)),CHARINDEX('.',CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max))) - 1) + '.' + REPLACE(RIGHT(CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max)), LEN(CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max))) - CHARINDEX('.',CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max)))),'.','') AS numeric(18,10))

  IF @Version >= 9.002047
  BEGIN
    SET @TokenServer = '$' + '(ESCAPE_SQUOTE(SRVR))'
    SET @TokenJobID = '$' + '(ESCAPE_SQUOTE(JOBID))'
    SET @TokenStepID = '$' + '(ESCAPE_SQUOTE(STEPID))'
    SET @TokenDate = '$' + '(ESCAPE_SQUOTE(STRTDT))'
    SET @TokenTime = '$' + '(ESCAPE_SQUOTE(STRTTM))'
  END
  ELSE
  BEGIN
    SET @TokenServer = '$' + '(SRVR)'
    SET @TokenJobID = '$' + '(JOBID)'
    SET @TokenStepID = '$' + '(STEPID)'
    SET @TokenDate = '$' + '(STRTDT)'
    SET @TokenTime = '$' + '(STRTTM)'
  END

  IF @Version >= 12
  BEGIN
    SET @TokenLogDirectory = '$' + '(ESCAPE_SQUOTE(SQLLOGDIR))'
  END

  SET @JobDescription = 'Source: https://ola.hallengren.com'
  SET @JobCategory = 'Database Maintenance'
  SET @JobOwner = SUSER_SNAME(0x01)

  SET @JobName01 = 'DatabaseBackup - SYSTEM_DATABASES - FULL'
  SET @JobCommand01 = 'sqlcmd -E -S ' + @TokenServer + ' -d ' + @DatabaseName + ' -Q "EXECUTE [dbo].[DatabaseBackup] @Databases = ''SYSTEM_DATABASES'', @Directory = ' + ISNULL('N''' + REPLACE(@BackupDirectory,'''','''''') + '''','NULL') + ', @BackupType = ''FULL'', @Verify = ''Y'', @CleanupTime = ' + ISNULL(CAST(@CleanupTime AS nvarchar),'NULL') + ', @CheckSum = ''Y''' + CASE WHEN @LogToTable = 'Y' THEN ', @LogToTable = ''Y''' ELSE '' END + '" -b'
  SET @OutputFile01 = COALESCE(@OutputFileDirectory,@TokenLogDirectory) + '\' + 'DatabaseBackup_' + @TokenJobID + '_' + @TokenStepID + '_' + @TokenDate + '_' + @TokenTime + '.txt'
  IF LEN(@OutputFile01) > 200 SET @OutputFile01 = COALESCE(@OutputFileDirectory,@TokenLogDirectory) + '\' + @TokenJobID + '_' + @TokenStepID + '_' + @TokenDate + '_' + @TokenTime + '.txt'
  IF LEN(@OutputFile01) > 200 SET @OutputFile01 = NULL

  SET @JobName02 = 'DatabaseBackup - USER_DATABASES - DIFF'
  SET @JobCommand02 = 'sqlcmd -E -S ' + @TokenServer + ' -d ' + @DatabaseName + ' -Q "EXECUTE [dbo].[DatabaseBackup] @Databases = ''USER_DATABASES'', @Directory = ' + ISNULL('N''' + REPLACE(@BackupDirectory,'''','''''') + '''','NULL') + ', @BackupType = ''DIFF'', @Verify = ''Y'', @CleanupTime = ' + ISNULL(CAST(@CleanupTime AS nvarchar),'NULL') + ', @CheckSum = ''Y''' + CASE WHEN @LogToTable = 'Y' THEN ', @LogToTable = ''Y''' ELSE '' END + '" -b'
  SET @OutputFile02 = COALESCE(@OutputFileDirectory,@TokenLogDirectory) + '\' + 'DatabaseBackup_' + @TokenJobID + '_' + @TokenStepID + '_' + @TokenDate + '_' + @TokenTime + '.txt'
  IF LEN(@OutputFile02) > 200 SET @OutputFile02 = COALESCE(@OutputFileDirectory,@TokenLogDirectory) + '\' + @TokenJobID + '_' + @TokenStepID + '_' + @TokenDate + '_' + @TokenTime + '.txt'
  IF LEN(@OutputFile02) > 200 SET @OutputFile02 = NULL

  SET @JobName03 = 'DatabaseBackup - USER_DATABASES - FULL'
  SET @JobCommand03 = 'sqlcmd -E -S ' + @TokenServer + ' -d ' + @DatabaseName + ' -Q "EXECUTE [dbo].[DatabaseBackup] @Databases = ''USER_DATABASES'', @Directory = ' + ISNULL('N''' + REPLACE(@BackupDirectory,'''','''''') + '''','NULL') + ', @BackupType = ''FULL'', @Verify = ''Y'', @CleanupTime = ' + ISNULL(CAST(@CleanupTime AS nvarchar),'NULL') + ', @CheckSum = ''Y''' + CASE WHEN @LogToTable = 'Y' THEN ', @LogToTable = ''Y''' ELSE '' END + '" -b'
  SET @OutputFile03 = COALESCE(@OutputFileDirectory,@TokenLogDirectory) + '\' + 'DatabaseBackup_' + @TokenJobID + '_' + @TokenStepID + '_' + @TokenDate + '_' + @TokenTime + '.txt'
  IF LEN(@OutputFile03) > 200 SET @OutputFile03 = COALESCE(@OutputFileDirectory,@TokenLogDirectory) + '\' + @TokenJobID + '_' + @TokenStepID + '_' + @TokenDate + '_' + @TokenTime + '.txt'
  IF LEN(@OutputFile03) > 200 SET @OutputFile03 = NULL

  SET @JobName04 = 'DatabaseBackup - USER_DATABASES - LOG'
  SET @JobCommand04 = 'sqlcmd -E -S ' + @TokenServer + ' -d ' + @DatabaseName + ' -Q "EXECUTE [dbo].[DatabaseBackup] @Databases = ''USER_DATABASES'', @Directory = ' + ISNULL('N''' + REPLACE(@BackupDirectory,'''','''''') + '''','NULL') + ', @BackupType = ''LOG'', @Verify = ''Y'', @CleanupTime = ' + ISNULL(CAST(@CleanupTime AS nvarchar),'NULL') + ', @CheckSum = ''Y''' + CASE WHEN @LogToTable = 'Y' THEN ', @LogToTable = ''Y''' ELSE '' END + '" -b'
  SET @OutputFile04 = COALESCE(@OutputFileDirectory,@TokenLogDirectory) + '\' + 'DatabaseBackup_' + @TokenJobID + '_' + @TokenStepID + '_' + @TokenDate + '_' + @TokenTime + '.txt'
  IF LEN(@OutputFile04) > 200 SET @OutputFile04 = COALESCE(@OutputFileDirectory,@TokenLogDirectory) + '\' + @TokenJobID + '_' + @TokenStepID + '_' + @TokenDate + '_' + @TokenTime + '.txt'
  IF LEN(@OutputFile04) > 200 SET @OutputFile04 = NULL

  SET @JobName05 = 'DatabaseIntegrityCheck - SYSTEM_DATABASES'
  SET @JobCommand05 = 'sqlcmd -E -S ' + @TokenServer + ' -d ' + @DatabaseName + ' -Q "EXECUTE [dbo].[DatabaseIntegrityCheck] @Databases = ''SYSTEM_DATABASES''' + CASE WHEN @LogToTable = 'Y' THEN ', @LogToTable = ''Y''' ELSE '' END + '" -b'
  SET @OutputFile05 = COALESCE(@OutputFileDirectory,@TokenLogDirectory) + '\' + 'DatabaseIntegrityCheck_' + @TokenJobID + '_' + @TokenStepID + '_' + @TokenDate + '_' + @TokenTime + '.txt'
  IF LEN(@OutputFile05) > 200 SET @OutputFile05 = COALESCE(@OutputFileDirectory,@TokenLogDirectory) + '\' + @TokenJobID + '_' + @TokenStepID + '_' + @TokenDate + '_' + @TokenTime + '.txt'
  IF LEN(@OutputFile05) > 200 SET @OutputFile05 = NULL

  SET @JobName06 = 'DatabaseIntegrityCheck - USER_DATABASES'
  SET @JobCommand06 = 'sqlcmd -E -S ' + @TokenServer + ' -d ' + @DatabaseName + ' -Q "EXECUTE [dbo].[DatabaseIntegrityCheck] @Databases = ''USER_DATABASES''' + CASE WHEN @LogToTable = 'Y' THEN ', @LogToTable = ''Y''' ELSE '' END + '" -b'
  SET @OutputFile06 = COALESCE(@OutputFileDirectory,@TokenLogDirectory) + '\' + 'DatabaseIntegrityCheck_' + @TokenJobID + '_' + @TokenStepID + '_' + @TokenDate + '_' + @TokenTime + '.txt'
  IF LEN(@OutputFile06) > 200 SET @OutputFile06 = COALESCE(@OutputFileDirectory,@TokenLogDirectory) + '\' + @TokenJobID + '_' + @TokenStepID + '_' + @TokenDate + '_' + @TokenTime + '.txt'
  IF LEN(@OutputFile06) > 200 SET @OutputFile06 = NULL

  SET @JobName07 = 'IndexOptimize - USER_DATABASES'
  SET @JobCommand07 = 'sqlcmd -E -S ' + @TokenServer + ' -d ' + @DatabaseName + ' -Q "EXECUTE [dbo].[IndexOptimize] @Databases = ''USER_DATABASES''' + CASE WHEN @LogToTable = 'Y' THEN ', @LogToTable = ''Y''' ELSE '' END + '" -b'
  SET @OutputFile07 = COALESCE(@OutputFileDirectory,@TokenLogDirectory) + '\' + 'IndexOptimize_' + @TokenJobID + '_' + @TokenStepID + '_' + @TokenDate + '_' + @TokenTime + '.txt'
  IF LEN(@OutputFile07) > 200 SET @OutputFile07 = COALESCE(@OutputFileDirectory,@TokenLogDirectory) + '\' + @TokenJobID + '_' + @TokenStepID + '_' + @TokenDate + '_' + @TokenTime + '.txt'
  IF LEN(@OutputFile07) > 200 SET @OutputFile07 = NULL

  SET @JobName08 = 'sp_delete_backuphistory'
  SET @JobCommand08 = 'sqlcmd -E -S ' + @TokenServer + ' -d ' + 'msdb' + ' -Q "DECLARE @CleanupDate datetime SET @CleanupDate = DATEADD(dd,-30,GETDATE()) EXECUTE dbo.sp_delete_backuphistory @oldest_date = @CleanupDate" -b'
  SET @OutputFile08 = COALESCE(@OutputFileDirectory,@TokenLogDirectory) + '\' + 'sp_delete_backuphistory_' + @TokenJobID + '_' + @TokenStepID + '_' + @TokenDate + '_' + @TokenTime + '.txt'
  IF LEN(@OutputFile08) > 200 SET @OutputFile08 = COALESCE(@OutputFileDirectory,@TokenLogDirectory) + '\' + @TokenJobID + '_' + @TokenStepID + '_' + @TokenDate + '_' + @TokenTime + '.txt'
  IF LEN(@OutputFile08) > 200 SET @OutputFile08 = NULL

  SET @JobName09 = 'sp_purge_jobhistory'
  SET @JobCommand09 = 'sqlcmd -E -S ' + @TokenServer + ' -d ' + 'msdb' + ' -Q "DECLARE @CleanupDate datetime SET @CleanupDate = DATEADD(dd,-30,GETDATE()) EXECUTE dbo.sp_purge_jobhistory @oldest_date = @CleanupDate" -b'
  SET @OutputFile09 = COALESCE(@OutputFileDirectory,@TokenLogDirectory) + '\' + 'sp_purge_jobhistory_' + @TokenJobID + '_' + @TokenStepID + '_' + @TokenDate + '_' + @TokenTime + '.txt'
  IF LEN(@OutputFile09) > 200 SET @OutputFile09 = COALESCE(@OutputFileDirectory,@TokenLogDirectory) + '\' + @TokenJobID + '_' + @TokenStepID + '_' + @TokenDate + '_' + @TokenTime + '.txt'
  IF LEN(@OutputFile09) > 200 SET @OutputFile09 = NULL

  SET @JobName10 = 'Output File Cleanup'
  SET @JobCommand10 = 'cmd /q /c "For /F "tokens=1 delims=" %v In (''ForFiles /P "' + COALESCE(@OutputFileDirectory,@TokenLogDirectory) + '" /m *_*_*_*.txt /d -30 2^>^&1'') do if EXIST "' + COALESCE(@OutputFileDirectory,@TokenLogDirectory) + '"\%v echo del "' + COALESCE(@OutputFileDirectory,@TokenLogDirectory) + '"\%v& del "' + COALESCE(@OutputFileDirectory,@TokenLogDirectory) + '"\%v"'
  SET @OutputFile10 = COALESCE(@OutputFileDirectory,@TokenLogDirectory) + '\' + 'OutputFileCleanup_' + @TokenJobID + '_' + @TokenStepID + '_' + @TokenDate + '_' + @TokenTime + '.txt'
  IF LEN(@OutputFile10) > 200 SET @OutputFile10 = COALESCE(@OutputFileDirectory,@TokenLogDirectory) + '\' + @TokenJobID + '_' + @TokenStepID + '_' + @TokenDate + '_' + @TokenTime + '.txt'
  IF LEN(@OutputFile10) > 200 SET @OutputFile10 = NULL

  SET @JobName11 = 'CommandLog Cleanup'
  SET @JobCommand11 = 'sqlcmd -E -S ' + @TokenServer + ' -d ' + @DatabaseName + ' -Q "DELETE FROM [dbo].[CommandLog] WHERE StartTime < DATEADD(dd,-30,GETDATE())" -b'
  SET @OutputFile11 = COALESCE(@OutputFileDirectory,@TokenLogDirectory) + '\' + 'CommandLogCleanup_' + @TokenJobID + '_' + @TokenStepID + '_' + @TokenDate + '_' + @TokenTime + '.txt'
  IF LEN(@OutputFile11) > 200 SET @OutputFile11 = COALESCE(@OutputFileDirectory,@TokenLogDirectory) + '\' + @TokenJobID + '_' + @TokenStepID + '_' + @TokenDate + '_' + @TokenTime + '.txt'
  IF LEN(@OutputFile11) > 200 SET @OutputFile11 = NULL

  IF NOT EXISTS (SELECT * FROM msdb.dbo.sysjobs WHERE [name] = @JobName01)
  BEGIN
    EXECUTE msdb.dbo.sp_add_job @job_name = @JobName01, @description = @JobDescription, @category_name = @JobCategory, @owner_login_name = @JobOwner
    EXECUTE msdb.dbo.sp_add_jobstep @job_name = @JobName01, @step_name = @JobName01, @subsystem = 'CMDEXEC', @command = @JobCommand01, @output_file_name = @OutputFile01
    EXECUTE msdb.dbo.sp_add_jobserver @job_name = @JobName01
  END

  IF NOT EXISTS (SELECT * FROM msdb.dbo.sysjobs WHERE [name] = @JobName02)
  BEGIN
    EXECUTE msdb.dbo.sp_add_job @job_name = @JobName02, @description = @JobDescription, @category_name = @JobCategory, @owner_login_name = @JobOwner
    EXECUTE msdb.dbo.sp_add_jobstep @job_name = @JobName02, @step_name = @JobName02, @subsystem = 'CMDEXEC', @command = @JobCommand02, @output_file_name = @OutputFile02
    EXECUTE msdb.dbo.sp_add_jobserver @job_name = @JobName02
  END

  IF NOT EXISTS (SELECT * FROM msdb.dbo.sysjobs WHERE [name] = @JobName03)
  BEGIN
    EXECUTE msdb.dbo.sp_add_job @job_name = @JobName03, @description = @JobDescription, @category_name = @JobCategory, @owner_login_name = @JobOwner
    EXECUTE msdb.dbo.sp_add_jobstep @job_name = @JobName03, @step_name = @JobName03, @subsystem = 'CMDEXEC', @command = @JobCommand03, @output_file_name = @OutputFile03
    EXECUTE msdb.dbo.sp_add_jobserver @job_name = @JobName03
  END

  IF NOT EXISTS (SELECT * FROM msdb.dbo.sysjobs WHERE [name] = @JobName04)
  BEGIN
    EXECUTE msdb.dbo.sp_add_job @job_name = @JobName04, @description = @JobDescription, @category_name = @JobCategory, @owner_login_name = @JobOwner
    EXECUTE msdb.dbo.sp_add_jobstep @job_name = @JobName04, @step_name = @JobName04, @subsystem = 'CMDEXEC', @command = @JobCommand04, @output_file_name = @OutputFile04
    EXECUTE msdb.dbo.sp_add_jobserver @job_name = @JobName04
  END

  IF NOT EXISTS (SELECT * FROM msdb.dbo.sysjobs WHERE [name] = @JobName05)
  BEGIN
    EXECUTE msdb.dbo.sp_add_job @job_name = @JobName05, @description = @JobDescription, @category_name = @JobCategory, @owner_login_name = @JobOwner
    EXECUTE msdb.dbo.sp_add_jobstep @job_name = @JobName05, @step_name = @JobName05, @subsystem = 'CMDEXEC', @command = @JobCommand05, @output_file_name = @OutputFile05
    EXECUTE msdb.dbo.sp_add_jobserver @job_name = @JobName05
  END

  IF NOT EXISTS (SELECT * FROM msdb.dbo.sysjobs WHERE [name] = @JobName06)
  BEGIN
    EXECUTE msdb.dbo.sp_add_job @job_name = @JobName06, @description = @JobDescription, @category_name = @JobCategory, @owner_login_name = @JobOwner
    EXECUTE msdb.dbo.sp_add_jobstep @job_name = @JobName06, @step_name = @JobName06, @subsystem = 'CMDEXEC', @command = @JobCommand06, @output_file_name = @OutputFile06
    EXECUTE msdb.dbo.sp_add_jobserver @job_name = @JobName06
  END

  IF NOT EXISTS (SELECT * FROM msdb.dbo.sysjobs WHERE [name] = @JobName07)
  BEGIN
    EXECUTE msdb.dbo.sp_add_job @job_name = @JobName07, @description = @JobDescription, @category_name = @JobCategory, @owner_login_name = @JobOwner
    EXECUTE msdb.dbo.sp_add_jobstep @job_name = @JobName07, @step_name = @JobName07, @subsystem = 'CMDEXEC', @command = @JobCommand07, @output_file_name = @OutputFile07
    EXECUTE msdb.dbo.sp_add_jobserver @job_name = @JobName07
  END

  IF NOT EXISTS (SELECT * FROM msdb.dbo.sysjobs WHERE [name] = @JobName08)
  BEGIN
    EXECUTE msdb.dbo.sp_add_job @job_name = @JobName08, @description = @JobDescription, @category_name = @JobCategory, @owner_login_name = @JobOwner
    EXECUTE msdb.dbo.sp_add_jobstep @job_name = @JobName08, @step_name = @JobName08, @subsystem = 'CMDEXEC', @command = @JobCommand08, @output_file_name = @OutputFile08
    EXECUTE msdb.dbo.sp_add_jobserver @job_name = @JobName08
  END

  IF NOT EXISTS (SELECT * FROM msdb.dbo.sysjobs WHERE [name] = @JobName09)
  BEGIN
    EXECUTE msdb.dbo.sp_add_job @job_name = @JobName09, @description = @JobDescription, @category_name = @JobCategory, @owner_login_name = @JobOwner
    EXECUTE msdb.dbo.sp_add_jobstep @job_name = @JobName09, @step_name = @JobName09, @subsystem = 'CMDEXEC', @command = @JobCommand09, @output_file_name = @OutputFile09
    EXECUTE msdb.dbo.sp_add_jobserver @job_name = @JobName09
  END

  IF NOT EXISTS (SELECT * FROM msdb.dbo.sysjobs WHERE [name] = @JobName10)
  BEGIN
    EXECUTE msdb.dbo.sp_add_job @job_name = @JobName10, @description = @JobDescription, @category_name = @JobCategory, @owner_login_name = @JobOwner
    EXECUTE msdb.dbo.sp_add_jobstep @job_name = @JobName10, @step_name = @JobName10, @subsystem = 'CMDEXEC', @command = @JobCommand10, @output_file_name = @OutputFile10
    EXECUTE msdb.dbo.sp_add_jobserver @job_name = @JobName10
  END

  IF NOT EXISTS (SELECT * FROM msdb.dbo.sysjobs WHERE [name] = @JobName11)
  BEGIN
    EXECUTE msdb.dbo.sp_add_job @job_name = @JobName11, @description = @JobDescription, @category_name = @JobCategory, @owner_login_name = @JobOwner
    EXECUTE msdb.dbo.sp_add_jobstep @job_name = @JobName11, @step_name = @JobName11, @subsystem = 'CMDEXEC', @command = @JobCommand11, @output_file_name = @OutputFile11
    EXECUTE msdb.dbo.sp_add_jobserver @job_name = @JobName11
  END
 END