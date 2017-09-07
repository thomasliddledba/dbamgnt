#### 

[Project](../../../../index.md) > [SERVER\\MSSQL1601](../../../index.md) > [User databases](../../index.md) > [dbamgnt](../index.md) > [Tables](Tables.md) > dbo.DefaultParms

# ![Tables](../Images/Table32.png) [dbo].[DefaultParms]

---

## <a name="#columns"></a>Columns

| Key | Name | Data Type | Max Length (Bytes) | Allow Nulls | Identity |
|---|---|---|---|---|---|
| [![Cluster Primary Key PK_DefaultParms: ID](../Images/pkcluster.png)](#indexes) | ID | int | 4 | NO | 1 - 1 |
|  | Parm | varchar(20) | 20 | YES |  |
|  | Value | varchar(128) | 128 | YES |  |


---

## <a name="#extendedproperties"></a>Extended Properties

| Name | Value |
|---|---|
| Author | Thomas Liddle |
| Description | Store Default Parameters for SQL Server Agent Jobs or for Stored Procedures.  This table must be called directly. |
| Source | http://www.thomasliddledba.com/ |


---

###### Author:  Thomas Liddle

###### Copyright 2017 - All Rights Reserved