#### 

# ![Stored Procedures](../../Images/StoredProcedure32.png) [dbo].[CommandExecute]

---

## <a name="#parameters"></a>Parameters

| Name | Data Type | Max Length (Bytes) |
|---|---|---|
| @Command | nvarchar(max) | max |
| @CommandType | nvarchar(max) | max |
| @Mode | int | 4 |
| @Comment | nvarchar(max) | max |
| @DatabaseName | nvarchar(max) | max |
| @SchemaName | nvarchar(max) | max |
| @ObjectName | nvarchar(max) | max |
| @ObjectType | nvarchar(max) | max |
| @IndexName | nvarchar(max) | max |
| @IndexType | int | 4 |
| @StatisticsName | nvarchar(max) | max |
| @PartitionNumber | int | 4 |
| @ExtendedInfo | xml | max |
| @LogToTable | nvarchar(max) | max |
| @Execute | nvarchar(max) | max |


---

## <a name="#extendedproperties"></a>Extended Properties

| Name | Value |
|---|---|
| Author | Ola Hallengren |
| Description | Support OLA Hallengren Scripts |
| Source | https://ola.hallengren.com/ |


---

## <a name="#uses"></a>Uses

* [[dbo].[CommandLog]](../../Tables/CommandLog.md)


---

## <a name="#usedby"></a>Used By

* [[dbo].[DatabaseBackup]](DatabaseBackup.md)
* [[dbo].[DatabaseIntegrityCheck]](DatabaseIntegrityCheck.md)
* [[dbo].[IndexOptimize]](IndexOptimize.md)
* [[dbo].[sp_DatabaseRestore]](sp_DatabaseRestore.md)


---

###### Author:  Thomas Liddle

###### Copyright 2017 - All Rights Reserved

