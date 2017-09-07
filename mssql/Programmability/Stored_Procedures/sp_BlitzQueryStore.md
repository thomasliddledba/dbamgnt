#### 

# ![Stored Procedures](../../Images/StoredProcedure32.png) [dbo].[sp_BlitzQueryStore]

---

## <a name="#parameters"></a>Parameters

| Name | Data Type | Max Length (Bytes) | Direction |
|---|---|---|---|
| @Help | bit | 1 |  |
| @DatabaseName | nvarchar(128) | 256 |  |
| @Top | int | 4 |  |
| @StartDate | datetime2 | 8 |  |
| @EndDate | datetime2 | 8 |  |
| @MinimumExecutionCount | int | 4 |  |
| @DurationFilter | decimal(38,4) | 17 |  |
| @StoredProcName | nvarchar(128) | 256 |  |
| @Failed | bit | 1 |  |
| @PlanIdFilter | int | 4 |  |
| @QueryIdFilter | int | 4 |  |
| @ExportToExcel | bit | 1 |  |
| @HideSummary | bit | 1 |  |
| @SkipXML | bit | 1 |  |
| @Debug | bit | 1 |  |
| @VersionDate | datetime | 8 | Out |


---

###### Author:  Thomas Liddle

###### Copyright 2017 - All Rights Reserved


