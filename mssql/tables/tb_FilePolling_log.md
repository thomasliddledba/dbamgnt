#### 

[Project](../../../../index.md) > [SERVER\\MSSQL1601](../../../index.md) > [User databases](../../index.md) > [dbamgnt](../index.md) > [Tables](Tables.md) > dbo.tb_FilePolling_log

# ![Tables](../../../../Images/Table32.png) [dbo].[tb_FilePolling_log]

---

## <a name="#columns"></a>Columns

| Key | Name | Data Type | Max Length (Bytes) | Allow Nulls | Identity |
|---|---|---|---|---|---|
| [![Cluster Primary Key PK_tb_FilePolling_log: LogID](../../../../Images/pkcluster.png)](#indexes) | LogID | int | 4 | NO | 1 - 1 |
|  | AppID | char(6) | 6 | YES |  |
|  | Status | char(1) | 1 | YES |  |
|  | MessageText | varchar(max) | max | YES |  |
|  | Date_Time | datetime | 8 | YES |  |


---

###### Author:  Thomas Liddle

###### Copyright 2017 - All Rights Reserved

###### Created: Tuesday, September 5, 2017 5:48:38 AM

