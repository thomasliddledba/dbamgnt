#### 

[Project](../../../../../index.md) > [SERVER\\MSSQL1601](../../../../index.md) > [User databases](../../../index.md) > [dbamgnt](../../index.md) > [Programmability](../index.md) > [Stored Procedures](Stored_Procedures.md) > dbo.DatabaseBackup

# ![Stored Procedures](../../../../../Images/StoredProcedure32.png) [dbo].[DatabaseBackup]

---

## <a name="#parameters"></a>Parameters

| Name | Data Type | Max Length (Bytes) |
|---|---|---|
| @Databases | nvarchar(max) | max |
| @Directory | nvarchar(max) | max |
| @BackupType | nvarchar(max) | max |
| @Verify | nvarchar(max) | max |
| @CleanupTime | int | 4 |
| @CleanupMode | nvarchar(max) | max |
| @Compress | nvarchar(max) | max |
| @CopyOnly | nvarchar(max) | max |
| @ChangeBackupType | nvarchar(max) | max |
| @BackupSoftware | nvarchar(max) | max |
| @CheckSum | nvarchar(max) | max |
| @BlockSize | int | 4 |
| @BufferCount | int | 4 |
| @MaxTransferSize | int | 4 |
| @NumberOfFiles | int | 4 |
| @CompressionLevel | int | 4 |
| @Description | nvarchar(max) | max |
| @Threads | int | 4 |
| @Throttle | int | 4 |
| @Encrypt | nvarchar(max) | max |
| @EncryptionAlgorithm | nvarchar(max) | max |
| @ServerCertificate | nvarchar(max) | max |
| @ServerAsymmetricKey | nvarchar(max) | max |
| @EncryptionKey | nvarchar(max) | max |
| @ReadWriteFileGroups | nvarchar(max) | max |
| @OverrideBackupPreference | nvarchar(max) | max |
| @NoRecovery | nvarchar(max) | max |
| @URL | nvarchar(max) | max |
| @Credential | nvarchar(max) | max |
| @MirrorDirectory | nvarchar(max) | max |
| @MirrorCleanupTime | int | 4 |
| @MirrorCleanupMode | nvarchar(max) | max |
| @AvailabilityGroups | nvarchar(max) | max |
| @Updateability | nvarchar(max) | max |
| @LogToTable | nvarchar(max) | max |
| @Execute | nvarchar(max) | max |


---

## <a name="#extendedproperties"></a>Extended Properties

| Name | Value |
|---|---|
| Author | Ola Hallengren |
| Description | DatabaseBackup is the SQL Server Maintenance Solution’s stored procedure for backing up databases. DatabaseBackup is supported on SQL Server 2005, SQL Server 2008, SQL Server 2008 R2, SQL Server 2012, SQL Server 2014, and SQL Server 2016. |
| Source | https://ola.hallengren.com/ |


---

## <a name="#uses"></a>Uses

* [[dbo].[CommandExecute]](CommandExecute.md)


---

## <a name="#usedby"></a>Used By

* [[dbo].[sp_AllNightLog]](sp_AllNightLog.md)


---

###### Author:  Thomas Liddle

###### Copyright 2017 - All Rights Reserved

###### Created: Tuesday, September 5, 2017 5:48:38 AM

