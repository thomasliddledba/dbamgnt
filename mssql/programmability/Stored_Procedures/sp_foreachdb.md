#### 

[Project](../../../../../index.md) > [SERVER\\MSSQL1601](../../../../index.md) > [User databases](../../../index.md) > [dbamgnt](../../index.md) > [Programmability](../index.md) > [Stored Procedures](Stored_Procedures.md) > dbo.sp_foreachdb

# ![Stored Procedures](../../../../../Images/StoredProcedure32.png) [dbo].[sp_foreachdb]

---

## <a name="#parameters"></a>Parameters

| Name | Data Type | Max Length (Bytes) | Direction |
|---|---|---|---|
| @command | nvarchar(max) | max |  |
| @replace_character | nchar | 1 |  |
| @print_dbname | bit | 1 |  |
| @print_command_only | bit | 1 |  |
| @suppress_quotename | bit | 1 |  |
| @system_only | bit | 1 |  |
| @user_only | bit | 1 |  |
| @name_pattern | nvarchar(300) | 600 |  |
| @database_list | nvarchar(max) | max |  |
| @exclude_list | nvarchar(max) | max |  |
| @recovery_model_desc | nvarchar(120) | 240 |  |
| @compatibility_level | tinyint | 1 |  |
| @state_desc | nvarchar(120) | 240 |  |
| @is_read_only | bit | 1 |  |
| @is_auto_close_on | bit | 1 |  |
| @is_auto_shrink_on | bit | 1 |  |
| @is_broker_enabled | bit | 1 |  |
| @VersionDate | datetime | 8 | Out |


---

###### Author:  Thomas Liddle

###### Copyright 2017 - All Rights Reserved

###### Created: Tuesday, September 5, 2017 5:48:38 AM

