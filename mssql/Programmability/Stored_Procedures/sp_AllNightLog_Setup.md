#### 

[Project](../../../../../index.md) > [SERVER\\MSSQL1601](../../../../index.md) > [User databases](../../../index.md) > [dbamgnt](../../index.md) > [Programmability](../index.md) > [Stored Procedures](Stored_Procedures.md) > dbo.sp_AllNightLog_Setup

# ![Stored Procedures](../../../../../Images/StoredProcedure32.png) [dbo].[sp_AllNightLog_Setup]

---

## <a name="#parameters"></a>Parameters

| Name | Data Type | Max Length (Bytes) | Direction |
|---|---|---|---|
| @RPOSeconds | bigint | 8 |  |
| @RTOSeconds | bigint | 8 |  |
| @BackupPath | nvarchar(max) | max |  |
| @RestorePath | nvarchar(max) | max |  |
| @Jobs | tinyint | 1 |  |
| @RunSetup | bit | 1 |  |
| @UpdateSetup | bit | 1 |  |
| @EnableBackupJobs | int | 4 |  |
| @EnableRestoreJobs | int | 4 |  |
| @Debug | bit | 1 |  |
| @Help | bit | 1 |  |
| @VersionDate | datetime | 8 | Out |


---

## <a name="#extendedproperties"></a>Extended Properties

| Name | Value |
|---|---|
| Author | Brent Ozar |
| Description | You manage a SQL Server instance with hundreds or thousands of mission-critical databases. You want to back them all up as quickly as possible, and one maintenance plan job isn’t going to cut it. |
| Source | https://www.brentozar.com/sp_allnightlog/ |


---

###### Author:  Thomas Liddle

###### Copyright 2017 - All Rights Reserved

###### Created: Tuesday, September 5, 2017 5:48:38 AM

