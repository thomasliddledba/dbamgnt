#### 

# ![Stored Procedures](../../Images/StoredProcedure32.png) [dbo].[sp_DataDump]

---

## <a name="#parameters"></a>Parameters

| Name | Data Type | Max Length (Bytes) | Direction |
|---|---|---|---|
| @AppID | varchar(max) | max |  |
| @ReportJobs | char | 1 |  |
| @TransactionID | varchar(max) | max | Out |


---

## <a name="#uses"></a>Uses

* [[dbo].[tb_DataDump_log]](../../Tables/tb_DataDump_log.md)
* [[dbo].[tb_DataDump_parm]](../../Tables/tb_DataDump_parm.md)


---

###### Author:  Thomas Liddle

###### Copyright 2017 - All Rights Reserved

