#### 

# ![Tables](../Images/Table32.png) [dbo].[tb_DataDump_log]

---

## <a name="#columns"></a>Columns

| Key | Name | Data Type | Max Length (Bytes) | Allow Nulls | Identity | Default |
|---|---|---|---|---|---|---|
| [![Cluster Primary Key PK_tb_DataDump_log: LogID](../Images/pkcluster.png)](#indexes) | LogID | int | 4 | NO | 1 - 1 |  |
|  | TransactionID | varchar(max) | max | NO |  |  |
|  | AppID | varchar(6) | 6 | NO |  |  |
|  | Date_Time | datetime | 8 | NO |  | (getdate()) |
|  | EventType | varchar(128) | 128 | NO |  |  |
|  | UserName | varchar(128) | 128 | NO |  | (suser_sname()) |
|  | MessageText | varchar(max) | max | NO |  |  |


---

## <a name="#usedby"></a>Used By

* [[dbo].[sp_DataDump]](../Programmability/Stored_Procedures/sp_DataDump.md)


---

###### Author:  Thomas Liddle

###### Copyright 2017 - All Rights Reserved
