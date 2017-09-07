#### 

# ![Stored Procedures](../../Images/StoredProcedure32.png) [dbo].[sp_DatabaseRestore]

---

## <a name="#parameters"></a>Parameters

| Name | Data Type | Max Length (Bytes) | Direction |
|---|---|---|---|
| @Database | nvarchar(128) | 256 |  |
| @RestoreDatabaseName | nvarchar(128) | 256 |  |
| @BackupPathFull | nvarchar(max) | max |  |
| @BackupPathDiff | nvarchar(max) | max |  |
| @BackupPathLog | nvarchar(max) | max |  |
| @MoveFiles | bit | 1 |  |
| @MoveDataDrive | nvarchar(260) | 520 |  |
| @MoveLogDrive | nvarchar(260) | 520 |  |
| @TestRestore | bit | 1 |  |
| @RunCheckDB | bit | 1 |  |
| @RestoreDiff | bit | 1 |  |
| @ContinueLogs | bit | 1 |  |
| @RunRecovery | bit | 1 |  |
| @StopAt | nvarchar(14) | 28 |  |
| @OnlyLogsAfter | nvarchar(14) | 28 |  |
| @Debug | int | 4 |  |
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

## <a name="#uses"></a>Uses

* [[dbo].[CommandExecute]](CommandExecute.md)


---

## <a name="#usedby"></a>Used By

* [[dbo].[sp_AllNightLog]](sp_AllNightLog.md)


---

###### Author:  Thomas Liddle

###### Copyright 2017 - All Rights Reserved

