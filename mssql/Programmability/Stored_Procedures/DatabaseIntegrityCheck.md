#### 

# ![Stored Procedures](../../Images/StoredProcedure32.png) [dbo].[DatabaseIntegrityCheck]

---

## <a name="#parameters"></a>Parameters

| Name | Data Type | Max Length (Bytes) |
|---|---|---|
| @Databases | nvarchar(max) | max |
| @CheckCommands | nvarchar(max) | max |
| @PhysicalOnly | nvarchar(max) | max |
| @NoIndex | nvarchar(max) | max |
| @ExtendedLogicalChecks | nvarchar(max) | max |
| @TabLock | nvarchar(max) | max |
| @FileGroups | nvarchar(max) | max |
| @Objects | nvarchar(max) | max |
| @MaxDOP | int | 4 |
| @AvailabilityGroups | nvarchar(max) | max |
| @AvailabilityGroupReplicas | nvarchar(max) | max |
| @Updateability | nvarchar(max) | max |
| @LockTimeout | int | 4 |
| @LogToTable | nvarchar(max) | max |
| @Execute | nvarchar(max) | max |


---

## <a name="#extendedproperties"></a>Extended Properties

| Name | Value |
|---|---|
| Author | Ola Hallengren |
| Description | DatabaseIntegrityCheck is the SQL Server Maintenance Solution’s stored procedure for checking the integrity of databases. DatabaseIntegrityCheck is supported on SQL Server 2005, SQL Server 2008, SQL Server 2008 R2, SQL Server 2012, SQL Server 2014, and SQL Server 2016. |
| Source | https://ola.hallengren.com/ |


---

## <a name="#uses"></a>Uses

* [[dbo].[CommandExecute]](CommandExecute.md)


---

###### Author:  Thomas Liddle

###### Copyright 2017 - All Rights Reserved

