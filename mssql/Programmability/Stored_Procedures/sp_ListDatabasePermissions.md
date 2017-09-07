#### 

[Project](../../../../../index.md) > [SERVER\\MSSQL1601](../../../../index.md) > [User databases](../../../index.md) > [dbamgnt](../../index.md) > [Programmability](../index.md) > [Stored Procedures](Stored_Procedures.md) > dbo.sp_ListDatabasePermissions

# ![Stored Procedures](../../../../../Images/StoredProcedure32.png) [dbo].[sp_ListDatabasePermissions]

---

## <a name="#parameters"></a>Parameters

| Name | Data Type | Max Length (Bytes) |
|---|---|---|
| @DatabaseName | varchar(128) | 128 |
| @GetOnlyTSQLColumn | char | 1 |


---

## <a name="#extendedproperties"></a>Extended Properties

| Name | Value |
|---|---|
| Author | Thomas Liddle |
| Description | This procedure will list all the permissions for a SQL Login.  Used mostly for documentation and copying of a SQL Login. |
| Source | http://www.thomasliddledba.com |


---

###### Author:  Thomas Liddle

###### Copyright 2017 - All Rights Reserved

###### Created: Tuesday, September 5, 2017 5:48:38 AM

