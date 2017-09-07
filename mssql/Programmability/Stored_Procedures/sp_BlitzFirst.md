#### 

# ![Stored Procedures](../../Images/StoredProcedure32.png) [dbo].[sp_BlitzFirst]

---

## <a name="#parameters"></a>Parameters

| Name | Data Type | Max Length (Bytes) | Direction |
|---|---|---|---|
| @Question | nvarchar(max) | max |  |
| @Help | tinyint | 1 |  |
| @AsOf | datetimeoffset | 10 |  |
| @ExpertMode | tinyint | 1 |  |
| @Seconds | int | 4 |  |
| @OutputType | varchar(20) | 20 |  |
| @OutputServerName | nvarchar(256) | 512 |  |
| @OutputDatabaseName | nvarchar(256) | 512 |  |
| @OutputSchemaName | nvarchar(256) | 512 |  |
| @OutputTableName | nvarchar(256) | 512 |  |
| @OutputTableNameFileStats | nvarchar(256) | 512 |  |
| @OutputTableNamePerfmonStats | nvarchar(256) | 512 |  |
| @OutputTableNameWaitStats | nvarchar(256) | 512 |  |
| @OutputXMLasNVARCHAR | tinyint | 1 |  |
| @FilterPlansByDatabase | varchar(max) | max |  |
| @CheckProcedureCache | tinyint | 1 |  |
| @FileLatencyThresholdMS | int | 4 |  |
| @SinceStartup | tinyint | 1 |  |
| @ShowSleepingSPIDs | tinyint | 1 |  |
| @VersionDate | datetime | 8 | Out |


---

## <a name="#extendedproperties"></a>Extended Properties

| Name | Value |
|---|---|
| Author | Brent Ozar |
| Description | Troubleshoot Slow SQL Servers |
| Source | https://www.brentozar.com/askbrent/ |


---

###### Author:  Thomas Liddle

###### Copyright 2017 - All Rights Reserved

