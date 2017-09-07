#### 

[Project](../../../../index.md) > [SERVER\\MSSQL1601](../../../index.md) > [User databases](../../index.md) > [dbamgnt](../index.md) > [Tables](Tables.md) > dbo.CommandLog

# ![Tables](../Images/Table32.png) [dbo].[CommandLog]

---

## <a name="#columns"></a>Columns

| Key | Name | Data Type | Max Length (Bytes) | Allow Nulls | Identity |
|---|---|---|---|---|---|
| [![Cluster Primary Key PK_CommandLog: ID](../Images/pkcluster.png)](#indexes) | ID | int | 4 | NO | 1 - 1 |
|  | DatabaseName | [sys].[sysname] | 256 | YES |  |
|  | SchemaName | [sys].[sysname] | 256 | YES |  |
|  | ObjectName | [sys].[sysname] | 256 | YES |  |
|  | ObjectType | char(2) | 2 | YES |  |
|  | IndexName | [sys].[sysname] | 256 | YES |  |
|  | IndexType | tinyint | 1 | YES |  |
|  | StatisticsName | [sys].[sysname] | 256 | YES |  |
|  | PartitionNumber | int | 4 | YES |  |
|  | ExtendedInfo | xml | max | YES |  |
|  | Command | nvarchar(max) | max | NO |  |
|  | CommandType | nvarchar(60) | 120 | NO |  |
|  | StartTime | datetime | 8 | NO |  |
|  | EndTime | datetime | 8 | YES |  |
|  | ErrorNumber | int | 4 | YES |  |
|  | ErrorMessage | nvarchar(max) | max | YES |  |


---

## <a name="#extendedproperties"></a>Extended Properties

| Name | Value |
|---|---|
| Author | Ola Hallengren |
| Description | Support OLA Hallengren Scripts |
| Source | https://ola.hallengren.com/ |


---

## <a name="#usedby"></a>Used By

* [[dbo].[CommandExecute]](../Programmability/Stored_Procedures/CommandExecute.md)


---

###### Author:  Thomas Liddle

###### Copyright 2017 - All Rights Reserved