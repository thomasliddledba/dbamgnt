#### 

[Project](../../../../../index.md) > [SERVER\\MSSQL1601](../../../../index.md) > [User databases](../../../index.md) > [dbamgnt](../../index.md) > [Programmability](../index.md) > [Stored Procedures](Stored_Procedures.md) > dbo.sp_BlitzCache

# ![Stored Procedures](../../../../../Images/StoredProcedure32.png) [dbo].[sp_BlitzCache]

---

## <a name="#parameters"></a>Parameters

| Name | Data Type | Max Length (Bytes) | Direction |
|---|---|---|---|
| @Help | bit | 1 |  |
| @Top | int | 4 |  |
| @SortOrder | varchar(50) | 50 |  |
| @UseTriggersAnyway | bit | 1 |  |
| @ExportToExcel | bit | 1 |  |
| @ExpertMode | tinyint | 1 |  |
| @OutputServerName | nvarchar(256) | 512 |  |
| @OutputDatabaseName | nvarchar(256) | 512 |  |
| @OutputSchemaName | nvarchar(256) | 512 |  |
| @OutputTableName | nvarchar(256) | 512 |  |
| @ConfigurationDatabaseName | nvarchar(128) | 256 |  |
| @ConfigurationSchemaName | nvarchar(256) | 512 |  |
| @ConfigurationTableName | nvarchar(256) | 512 |  |
| @DurationFilter | decimal(38,4) | 17 |  |
| @HideSummary | bit | 1 |  |
| @IgnoreSystemDBs | bit | 1 |  |
| @OnlyQueryHashes | varchar(max) | max |  |
| @IgnoreQueryHashes | varchar(max) | max |  |
| @OnlySqlHandles | varchar(max) | max |  |
| @IgnoreSqlHandles | varchar(max) | max |  |
| @QueryFilter | varchar(10) | 10 |  |
| @DatabaseName | nvarchar(128) | 256 |  |
| @StoredProcName | nvarchar(128) | 256 |  |
| @Reanalyze | bit | 1 |  |
| @SkipAnalysis | bit | 1 |  |
| @BringThePain | bit | 1 |  |
| @MinimumExecutionCount | int | 4 |  |
| @VersionDate | datetime | 8 | Out |


---

## <a name="#extendedproperties"></a>Extended Properties

| Name | Value |
|---|---|
| Author | Brent Ozar |
| Description | Fast tool to find the worst queries in the SQL Server plan cache, tell you why they’re bad, and even tell you what you can do about them. |
| Source | https://www.brentozar.com/blitzcache/ |


---

###### Author:  Thomas Liddle

###### Copyright 2017 - All Rights Reserved

###### Created: Tuesday, September 5, 2017 5:48:38 AM

