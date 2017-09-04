USE [dbamgnt]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tb_DataDump_log]') AND type in (N'U'))
ALTER TABLE [dbo].[tb_DataDump_log] DROP CONSTRAINT IF EXISTS [DF_tb_DataDump_log_UserName]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tb_DataDump_log]') AND type in (N'U'))
ALTER TABLE [dbo].[tb_DataDump_log] DROP CONSTRAINT IF EXISTS [DF_tb_DataDump_log_Date_Time]
GO
/****** Object:  Table [dbo].[tb_DataDump_log]    Script Date: 9/4/2017 8:26:47 AM ******/
DROP TABLE IF EXISTS [dbo].[tb_DataDump_log]
GO
/****** Object:  Table [dbo].[tb_DataDump_log]    Script Date: 9/4/2017 8:26:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tb_DataDump_log]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tb_DataDump_log](
	[LogID] [int] IDENTITY(1,1) NOT NULL,
	[TransactionID] [varchar](max) NOT NULL,
	[AppID] [varchar](6) NOT NULL,
	[Date_Time] [datetime] NOT NULL,
	[EventType] [varchar](128) NOT NULL,
	[UserName] [varchar](128) NOT NULL,
	[MessageText] [varchar](max) NOT NULL,
 CONSTRAINT [PK_tb_DataDump_log] PRIMARY KEY CLUSTERED 
(
	[LogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_tb_DataDump_log_Date_Time]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tb_DataDump_log] ADD  CONSTRAINT [DF_tb_DataDump_log_Date_Time]  DEFAULT (getdate()) FOR [Date_Time]
END

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_tb_DataDump_log_UserName]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tb_DataDump_log] ADD  CONSTRAINT [DF_tb_DataDump_log_UserName]  DEFAULT (suser_sname()) FOR [UserName]
END

GO
