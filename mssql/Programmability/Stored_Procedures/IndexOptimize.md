#### 


# ![Stored Procedures](../../Images/StoredProcedure32.png) [dbo].[IndexOptimize]

---

## <a name="#parameters"></a>Parameters

| Name | Data Type | Max Length (Bytes) |
|---|---|---|
| @Databases | nvarchar(max) | max |
| @FragmentationLow | nvarchar(max) | max |
| @FragmentationMedium | nvarchar(max) | max |
| @FragmentationHigh | nvarchar(max) | max |
| @FragmentationLevel1 | int | 4 |
| @FragmentationLevel2 | int | 4 |
| @PageCountLevel | int | 4 |
| @SortInTempdb | nvarchar(max) | max |
| @MaxDOP | int | 4 |
| @FillFactor | int | 4 |
| @PadIndex | nvarchar(max) | max |
| @LOBCompaction | nvarchar(max) | max |
| @UpdateStatistics | nvarchar(max) | max |
| @OnlyModifiedStatistics | nvarchar(max) | max |
| @StatisticsSample | int | 4 |
| @StatisticsResample | nvarchar(max) | max |
| @PartitionLevel | nvarchar(max) | max |
| @MSShippedObjects | nvarchar(max) | max |
| @Indexes | nvarchar(max) | max |
| @TimeLimit | int | 4 |
| @Delay | int | 4 |
| @WaitAtLowPriorityMaxDuration | int | 4 |
| @WaitAtLowPriorityAbortAfterWait | nvarchar(max) | max |
| @AvailabilityGroups | nvarchar(max) | max |
| @LockTimeout | int | 4 |
| @LogToTable | nvarchar(max) | max |
| @Execute | nvarchar(max) | max |


---

## <a name="#extendedproperties"></a>Extended Properties

| Name | Value |
|---|---|
| Author | Ola Hallengren |
| Description | IndexOptimize is the SQL Server Maintenance Solution’s stored procedure for rebuilding and reorganizing indexes and updating statistics. IndexOptimize is supported on SQL Server 2005, SQL Server 2008, SQL Server 2008 R2, SQL Server 2012, SQL Server 2014, and SQL Server 2016. |
| Source | https://ola.hallengren.com/ |


---

## <a name="#uses"></a>Uses

* [[dbo].[CommandExecute]](CommandExecute.md)


---

###### Author:  Thomas Liddle

###### Copyright 2017 - All Rights Reserved

