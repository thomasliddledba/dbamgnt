#### 

[Project](../../../../../index.md) > [SERVER\\MSSQL1601](../../../../index.md) > [User databases](../../../index.md) > [dbamgnt](../../index.md) > [Programmability](../index.md) > [Stored Procedures](Stored_Procedures.md) > dbo.sp_Blitz

# ![Stored Procedures](../../../../../Images/StoredProcedure32.png) [dbo].[sp_Blitz]

---

## <a name="#parameters"></a>Parameters

| Name | Data Type | Max Length (Bytes) | Direction |
|---|---|---|---|
| @Help | tinyint | 1 |  |
| @CheckUserDatabaseObjects | tinyint | 1 |  |
| @CheckProcedureCache | tinyint | 1 |  |
| @OutputType | varchar(20) | 20 |  |
| @OutputProcedureCache | tinyint | 1 |  |
| @CheckProcedureCacheFilter | varchar(10) | 10 |  |
| @CheckServerInfo | tinyint | 1 |  |
| @SkipChecksServer | nvarchar(256) | 512 |  |
| @SkipChecksDatabase | nvarchar(256) | 512 |  |
| @SkipChecksSchema | nvarchar(256) | 512 |  |
| @SkipChecksTable | nvarchar(256) | 512 |  |
| @IgnorePrioritiesBelow | int | 4 |  |
| @IgnorePrioritiesAbove | int | 4 |  |
| @OutputServerName | nvarchar(256) | 512 |  |
| @OutputDatabaseName | nvarchar(256) | 512 |  |
| @OutputSchemaName | nvarchar(256) | 512 |  |
| @OutputTableName | nvarchar(256) | 512 |  |
| @OutputXMLasNVARCHAR | tinyint | 1 |  |
| @EmailRecipients | varchar(max) | max |  |
| @EmailProfile | sysname | 256 |  |
| @SummaryMode | tinyint | 1 |  |
| @BringThePain | tinyint | 1 |  |
| @Debug | tinyint | 1 |  |
| @VersionDate | datetime | 8 | Out |


---

## <a name="#extendedproperties"></a>Extended Properties

| Name | Value |
|---|---|
| Author | Brent Ozar |
| Description | Free SQL Server health check stored procedure that looks for a lot of common health and performance issues. If you just use the default parameters, you’ll get a prioritized list of problems, but by tweaking the input parameters, you can affect how sp_Blitz® runs |
| Source | https://www.brentozar.com/blitz/documentation/ |


---

###### Author:  Thomas Liddle

###### Copyright 2017 - All Rights Reserved

###### Created: Tuesday, September 5, 2017 5:48:38 AM

