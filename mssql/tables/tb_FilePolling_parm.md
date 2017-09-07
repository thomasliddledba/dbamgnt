#### 

# ![Tables](../../../../Images/Table32.png) [dbo].[tb_FilePolling_parm]

---

## <a name="#columns"></a>Columns

| Key | Name | Data Type | Max Length (Bytes) | Allow Nulls |
|---|---|---|---|---|
| [![Cluster Primary Key PK_tb_FilePolling_parm: AppID](../Images/pkcluster.png)](#indexes) | AppID | char(6) | 6 | NO |
|  | FileName | varchar(255) | 255 | NO |
|  | FileLocation | varchar(1024) | 1024 | NO |
|  | Description | varchar(4096) | 4096 | YES |
|  | StopTime | varchar(8) | 8 | YES |
|  | LastStatus | char(1) | 1 | YES |
|  | LastStatusDateTime | datetime | 8 | YES |
|  | LastStatusDescription | varchar(4096) | 4096 | YES |


---

## <a name="#usedby"></a>Used By

* [[dbo].[sp_DataLoad]](../Programmability/Stored_Procedures/sp_DataLoad.md)


---

###### Author:  Thomas Liddle

###### Copyright 2017 - All Rights Reserved
