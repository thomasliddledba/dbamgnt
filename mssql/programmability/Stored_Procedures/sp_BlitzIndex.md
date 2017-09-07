#### 

[Project](../../../../../index.md) > [SERVER\\MSSQL1601](../../../../index.md) > [User databases](../../../index.md) > [dbamgnt](../../index.md) > [Programmability](../index.md) > [Stored Procedures](Stored_Procedures.md) > dbo.sp_BlitzIndex

# ![Stored Procedures](../../../../../Images/StoredProcedure32.png) [dbo].[sp_BlitzIndex]

---

## <a name="#parameters"></a>Parameters

| Name | Data Type | Max Length (Bytes) | Direction |
|---|---|---|---|
| @DatabaseName | nvarchar(128) | 256 |  |
| @SchemaName | nvarchar(128) | 256 |  |
| @TableName | nvarchar(128) | 256 |  |
| @Mode | tinyint | 1 |  |
| @Filter | tinyint | 1 |  |
| @SkipPartitions | bit | 1 |  |
| @SkipStatistics | bit | 1 |  |
| @GetAllDatabases | bit | 1 |  |
| @BringThePain | bit | 1 |  |
| @ThresholdMB | int | 4 |  |
| @OutputServerName | nvarchar(256) | 512 |  |
| @OutputDatabaseName | nvarchar(256) | 512 |  |
| @OutputSchemaName | nvarchar(256) | 512 |  |
| @OutputTableName | nvarchar(256) | 512 |  |
| @Help | tinyint | 1 |  |
| @VersionDate | datetime | 8 | Out |


---

## <a name="#extendedproperties"></a>Extended Properties

| Name | Value |
|---|---|
| Author | Brent Ozar |
| Description | does a sanity check on your database and diagnoses your indexes major disorders, then reports back to you. Each disorder has a URL that explains what to look for and how to handle the issue. |
| Source | https://www.brentozar.com/blitzindex/ |


---

###### Author:  Thomas Liddle

###### Copyright 2017 - All Rights Reserved

###### Created: Tuesday, September 5, 2017 5:48:38 AM

