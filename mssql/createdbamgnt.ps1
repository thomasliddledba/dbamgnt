
Param(
	[Parameter(Mandatory=$true)]
		[string]$SQLServerName,
	[Parameter(Mandatory=$true)]
		[string]$WindowsAuth,
	[string]$SQLLoginName,
	[string]$SQLLoginPWD
)
Write-Host "#########################################################"
Write-Host "		DBAMgnt Utility DB                           "
Write-Host " Source https://github.com/thomasliddledba/dbamgnt       "
Write-Host "#########################################################"
Write-Host "SQL Server Name: $SQLServerName"
Write-Host "Windows Authenication:  $WindowsAuth"
Write-Host "SQL Server Login Name:  $SQLLoginName"
$CurrentLocation=Get-Location


Write-Host "Create dbamgnt Database"
$QueryFile = "$CurrentLocation\dbamgnt.Database.sql"
sqlcmd -S $SQLServerName -E -i $QueryFile

Write-Host "Create Tables in dbamgnt"
$QueryFile = "$CurrentLocation\dbo.CommandLog.Table.sql"
sqlcmd -S $SQLServerName -E -i $QueryFile

$QueryFile = "$CurrentLocation\dbo.DefaultParms.Table.sql"
sqlcmd -S $SQLServerName -E -i $QueryFile

$QueryFile = "$CurrentLocation\dbo.DefaultParms.Data.sql"
sqlcmd -S $SQLServerName -E -i $QueryFile

Write-Host "Create Stored Procedures in dbamgnt"
$QueryFile = "$CurrentLocation\dbo.CommandExecute.StoredProcedure.sql"
sqlcmd -S $SQLServerName -E -i $QueryFile

$QueryFile = "$CurrentLocation\dbo.DatabaseBackup.StoredProcedure.sql"
sqlcmd -S $SQLServerName -E -i $QueryFile

$QueryFile = "$CurrentLocation\dbo.DatabaseIntegrityCheck.StoredProcedure.sql"
sqlcmd -S $SQLServerName -E -i $QueryFile

$QueryFile = "$CurrentLocation\dbo.IndexOptimize.StoredProcedure.sql"
sqlcmd -S $SQLServerName -E -i $QueryFile

$QueryFile = "$CurrentLocation\dbo.sp_DatabaseRestore.StoredProcedure.sql"
sqlcmd -S $SQLServerName -E -i $QueryFile

$QueryFile = "$CurrentLocation\dbo.sp_AllNightLog.StoredProcedure.sql"
sqlcmd -S $SQLServerName -E -i $QueryFile

$QueryFile = "$CurrentLocation\dbo.sp_AllNightLog_Setup.StoredProcedure.sql"
sqlcmd -S $SQLServerName -E -i $QueryFile

$QueryFile = "$CurrentLocation\dbo.sp_Blitz.StoredProcedure.sql"
sqlcmd -S $SQLServerName -E -i $QueryFile

$QueryFile = "$CurrentLocation\dbo.sp_BlitzBackups.StoredProcedure.sql"
sqlcmd -S $SQLServerName -E -i $QueryFile

$QueryFile = "$CurrentLocation\dbo.sp_BlitzCache.StoredProcedure.sql"
sqlcmd -S $SQLServerName -E -i $QueryFile

$QueryFile = "$CurrentLocation\dbo.sp_BlitzFirst.StoredProcedure.sql"
sqlcmd -S $SQLServerName -E -i $QueryFile

$QueryFile = "$CurrentLocation\dbo.sp_BlitzIndex.StoredProcedure.sql"
sqlcmd -S $SQLServerName -E -i $QueryFile

$QueryFile = "$CurrentLocation\dbo.sp_BlitzQueryStore.StoredProcedure.sql"
sqlcmd -S $SQLServerName -E -i $QueryFile

$QueryFile = "$CurrentLocation\dbo.sp_BlitzWho.StoredProcedure.sql"
sqlcmd -S $SQLServerName -E -i $QueryFile

$QueryFile = "$CurrentLocation\dbo.sp_foreachdb.StoredProcedure.sql"
sqlcmd -S $SQLServerName -E -i $QueryFile

$QueryFile = "$CurrentLocation\dbo.sp_hexadecimal.StoredProcedure.sql"
sqlcmd -S $SQLServerName -E -i $QueryFile

$QueryFile = "$CurrentLocation\dbo.sp_help_revlogin.StoredProcedure.sql"
sqlcmd -S $SQLServerName -E -i $QueryFile

$QueryFile = "$CurrentLocation\dbamgnt.AgentJobs.sql"
sqlcmd -S $SQLServerName -E -i $QueryFile

Write-Host "Disconnected from $SQLServerName"