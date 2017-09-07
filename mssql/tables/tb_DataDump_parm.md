#### 

[Project](../../../../index.md) > [SERVER\\MSSQL1601](../../../index.md) > [User databases](../../index.md) > [dbamgnt](../index.md) > [Tables](Tables.md) > dbo.tb_DataDump_parm

# ![Tables](../../../../Images/Table32.png) [dbo].[tb_DataDump_parm]

---

## <a name="#columns"></a>Columns

| Key | Name | Data Type | Max Length (Bytes) | Allow Nulls | Default |
|---|---|---|---|---|---|
| [![Cluster Primary Key PK_tb_DataDump_parm_1: AppID](../../../../Images/pkcluster.png)](#indexes) | AppID | char(6) | 6 | NO |  |
|  | DatabaseName | varchar(512) | 512 | NO |  |
|  | ObjectName | varchar(512) | 512 | NO |  |
|  | FileLocation | varchar(512) | 512 | NO |  |
|  | FileName | varchar(512) | 512 | NO |  |
|  | BackupFile | char(1) | 1 | NO |  |
|  | FieldTerminator | char(4) | 4 | NO | ('\\t') |
|  | RowTerminator | char(4) | 4 | NO | ('\\r\\n') |
|  | UseCharDataType | char(1) | 1 | NO | ('Y') |
|  | IncludeColumnHeaders | char(1) | 1 | NO | ('N') |
|  | IncludeCustomHeader | char(1) | 1 | NO | ('N') |
|  | BatchSize | int | 4 | NO | ((1000)) |
|  | ZipFile | char(1) | 1 | NO |  |
|  | CopyToAltLocation1 | varchar(max) | max | YES |  |
|  | CopyToAltLocation2 | varchar(max) | max | YES |  |
|  | FTPInd | char(1) | 1 | YES | ('N') |
|  | FTPServerName | varchar(512) | 512 | YES |  |
|  | FTPUserName | varchar(512) | 512 | YES |  |
|  | FTPPassword | varbinary(8000) | 8000 | YES |  |
|  | FTPDirectory | varchar(2048) | 2048 | YES | (' ') |
|  | FTPArguments | varchar(2048) | 2048 | YES |  |
|  | Enabled | char(1) | 1 | NO | ('Y') |


---

## <a name="#usedby"></a>Used By

* [[dbo].[sp_DataDump]](../Programmability/Stored_Procedures/sp_DataDump.md)


---

###### Author:  Thomas Liddle

###### Copyright 2017 - All Rights Reserved

###### Created: Tuesday, September 5, 2017 5:48:38 AM

