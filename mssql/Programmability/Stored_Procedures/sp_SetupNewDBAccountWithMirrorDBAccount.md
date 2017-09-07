#### 

[Project](../../../../../index.md) > [SERVER\\MSSQL1601](../../../../index.md) > [User databases](../../../index.md) > [dbamgnt](../../index.md) > [Programmability](../index.md) > [Stored Procedures](Stored_Procedures.md) > dbo.sp_SetupNewDBAccountWithMirrorDBAccount

# ![Stored Procedures](../../../../../Images/StoredProcedure32.png) [dbo].[sp_SetupNewDBAccountWithMirrorDBAccount]

---

## <a name="#parameters"></a>Parameters

| Name | Data Type | Max Length (Bytes) |
|---|---|---|
| @MirrorAccount | varchar(255) | 255 |
| @NewUserAccount | varchar(255) | 255 |
| @IsNewUserAccountWindowsLogin | int | 4 |
| @IsNewUserAccountWindowsGroup | int | 4 |
| @OutputTSQLCode | char | 1 |
| @MirrorAccountLDAPName | varchar(255) | 255 |
| @NewUserAccountLDAPName | varchar(255) | 255 |


---

###### Author:  Thomas Liddle

###### Copyright 2017 - All Rights Reserved

###### Created: Tuesday, September 5, 2017 5:48:38 AM

