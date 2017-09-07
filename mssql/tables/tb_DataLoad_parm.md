#### 

[Project](../../../../index.md) > [SERVER\\MSSQL1601](../../../index.md) > [User databases](../../index.md) > [dbamgnt](../index.md) > [Tables](Tables.md) > dbo.tb_DataLoad_parm

# ![Tables](../../../../Images/Table32.png) [dbo].[tb_DataLoad_parm]

---

## <a name="#columns"></a>Columns

| Key | Name | Data Type | Max Length (Bytes) | Allow Nulls | Default |
|---|---|---|---|---|---|
| [![Cluster Primary Key PK_tb_DataLoad_parm: AppID](../../../../Images/pkcluster.png)](#indexes) | AppID | char(6) | 6 | NO |  |
|  | PollFileAppID | char(6) | 6 | YES |  |
|  | SourceFileLocation | varchar(2048) | 2048 | YES |  |
|  | DestinationDatabaseName | varchar(128) | 128 | NO |  |
|  | DestinationTableName | varchar(128) | 128 | NO |  |
|  | TruncateDestinationTable | char(1) | 1 | NO |  |
|  | FormatFileLocation | varchar(255) | 255 | NO |  |
|  | StartRow | int | 4 | NO | ((-1)) |
|  | LASTROW | int | 4 | NO | ((-1)) |
|  | KEEPIDENTITY | char(1) | 1 | NO | ('N') |
|  | KEEPNULLS | char(1) | 1 | NO | ('N') |
|  | BATCHSIZE | int | 4 | NO | ((1000)) |
|  | ENABLED | char(1) | 1 | NO | ('Y') |


---

## <a name="#usedby"></a>Used By

* [[dbo].[sp_DataLoad]](../Programmability/Stored_Procedures/sp_DataLoad.md)


---

###### Author:  Thomas Liddle

###### Copyright 2017 - All Rights Reserved

###### Created: Tuesday, September 5, 2017 5:48:38 AM

