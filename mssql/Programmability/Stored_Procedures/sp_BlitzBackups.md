#### 

# ![Stored Procedures](../../Images/StoredProcedure32.png) [dbo].[sp_BlitzBackups]

---

## <a name="#parameters"></a>Parameters

| Name | Data Type | Max Length (Bytes) | Direction |
|---|---|---|---|
| @Help | tinyint | 1 |  |
| @HoursBack | int | 4 |  |
| @MSDBName | nvarchar(256) | 512 |  |
| @AGName | nvarchar(256) | 512 |  |
| @RestoreSpeedFullMBps | int | 4 |  |
| @RestoreSpeedDiffMBps | int | 4 |  |
| @RestoreSpeedLogMBps | int | 4 |  |
| @Debug | tinyint | 1 |  |
| @PushBackupHistoryToListener | bit | 1 |  |
| @WriteBackupsToListenerName | nvarchar(256) | 512 |  |
| @WriteBackupsToDatabaseName | nvarchar(256) | 512 |  |
| @WriteBackupsLastHours | int | 4 |  |
| @VersionDate | date | 3 | Out |


---

## <a name="#extendedproperties"></a>Extended Properties

| Name | Value |
|---|---|
| Author | Brent Ozar |
| Description | Reviews your backup information to determine how much data did you lose if you server went down. |
| Source | https://www.brentozar.com/archive/2017/05/announcing-sp_blitzbackups-check-wreck/ |


---

###### Author:  Thomas Liddle

###### Copyright 2017 - All Rights Reserved

