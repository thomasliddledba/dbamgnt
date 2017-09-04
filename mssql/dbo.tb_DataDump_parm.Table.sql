USE [dbamgnt]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tb_DataDump_parm]') AND type in (N'U'))
ALTER TABLE [dbo].[tb_DataDump_parm] DROP CONSTRAINT IF EXISTS [DF_tb_DataDump_parm_Enabled]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tb_DataDump_parm]') AND type in (N'U'))
ALTER TABLE [dbo].[tb_DataDump_parm] DROP CONSTRAINT IF EXISTS [DF_tb_DataDump_parm_FTPDirectory]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tb_DataDump_parm]') AND type in (N'U'))
ALTER TABLE [dbo].[tb_DataDump_parm] DROP CONSTRAINT IF EXISTS [DF_tb_DataDump_parm_FTPInd]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tb_DataDump_parm]') AND type in (N'U'))
ALTER TABLE [dbo].[tb_DataDump_parm] DROP CONSTRAINT IF EXISTS [DF_tb_DataDump_parm_BatchSize]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tb_DataDump_parm]') AND type in (N'U'))
ALTER TABLE [dbo].[tb_DataDump_parm] DROP CONSTRAINT IF EXISTS [DF_tb_DataDump_parm_IncludeCustomerHeader]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tb_DataDump_parm]') AND type in (N'U'))
ALTER TABLE [dbo].[tb_DataDump_parm] DROP CONSTRAINT IF EXISTS [DF_tb_DataDump_parm_IncludeColumnHeaders]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tb_DataDump_parm]') AND type in (N'U'))
ALTER TABLE [dbo].[tb_DataDump_parm] DROP CONSTRAINT IF EXISTS [DF_tb_DataDump_parm_UseCharDataType]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tb_DataDump_parm]') AND type in (N'U'))
ALTER TABLE [dbo].[tb_DataDump_parm] DROP CONSTRAINT IF EXISTS [DF_tb_DataDump_parm_RowTerminator]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tb_DataDump_parm]') AND type in (N'U'))
ALTER TABLE [dbo].[tb_DataDump_parm] DROP CONSTRAINT IF EXISTS [DF_tb_DataDump_parm_FieldTerminator]
GO
/****** Object:  Table [dbo].[tb_DataDump_parm]    Script Date: 9/4/2017 8:26:47 AM ******/
DROP TABLE IF EXISTS [dbo].[tb_DataDump_parm]
GO
/****** Object:  Table [dbo].[tb_DataDump_parm]    Script Date: 9/4/2017 8:26:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tb_DataDump_parm]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tb_DataDump_parm](
	[AppID] [char](6) NOT NULL,
	[DatabaseName] [varchar](512) NOT NULL,
	[ObjectName] [varchar](512) NOT NULL,
	[FileLocation] [varchar](512) NOT NULL,
	[FileName] [varchar](512) NOT NULL,
	[BackupFile] [char](1) NOT NULL,
	[FieldTerminator] [char](4) NOT NULL,
	[RowTerminator] [char](4) NOT NULL,
	[UseCharDataType] [char](1) NOT NULL,
	[IncludeColumnHeaders] [char](1) NOT NULL,
	[IncludeCustomHeader] [char](1) NOT NULL,
	[BatchSize] [int] NOT NULL,
	[ZipFile] [char](1) NOT NULL,
	[CopyToAltLocation1] [varchar](max) NULL,
	[CopyToAltLocation2] [varchar](max) NULL,
	[FTPInd] [char](1) NULL,
	[FTPServerName] [varchar](512) NULL,
	[FTPUserName] [varchar](512) NULL,
	[FTPPassword] [varbinary](8000) NULL,
	[FTPDirectory] [varchar](2048) NULL,
	[FTPArguments] [varchar](2048) NULL,
	[Enabled] [char](1) NOT NULL,
 CONSTRAINT [PK_tb_DataDump_parm_1] PRIMARY KEY CLUSTERED 
(
	[AppID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_tb_DataDump_parm_FieldTerminator]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tb_DataDump_parm] ADD  CONSTRAINT [DF_tb_DataDump_parm_FieldTerminator]  DEFAULT ('\t') FOR [FieldTerminator]
END

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_tb_DataDump_parm_RowTerminator]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tb_DataDump_parm] ADD  CONSTRAINT [DF_tb_DataDump_parm_RowTerminator]  DEFAULT ('\r\n') FOR [RowTerminator]
END

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_tb_DataDump_parm_UseCharDataType]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tb_DataDump_parm] ADD  CONSTRAINT [DF_tb_DataDump_parm_UseCharDataType]  DEFAULT ('Y') FOR [UseCharDataType]
END

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_tb_DataDump_parm_IncludeColumnHeaders]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tb_DataDump_parm] ADD  CONSTRAINT [DF_tb_DataDump_parm_IncludeColumnHeaders]  DEFAULT ('N') FOR [IncludeColumnHeaders]
END

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_tb_DataDump_parm_IncludeCustomerHeader]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tb_DataDump_parm] ADD  CONSTRAINT [DF_tb_DataDump_parm_IncludeCustomerHeader]  DEFAULT ('N') FOR [IncludeCustomHeader]
END

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_tb_DataDump_parm_BatchSize]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tb_DataDump_parm] ADD  CONSTRAINT [DF_tb_DataDump_parm_BatchSize]  DEFAULT ((1000)) FOR [BatchSize]
END

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_tb_DataDump_parm_FTPInd]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tb_DataDump_parm] ADD  CONSTRAINT [DF_tb_DataDump_parm_FTPInd]  DEFAULT ('N') FOR [FTPInd]
END

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_tb_DataDump_parm_FTPDirectory]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tb_DataDump_parm] ADD  CONSTRAINT [DF_tb_DataDump_parm_FTPDirectory]  DEFAULT (' ') FOR [FTPDirectory]
END

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_tb_DataDump_parm_Enabled]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tb_DataDump_parm] ADD  CONSTRAINT [DF_tb_DataDump_parm_Enabled]  DEFAULT ('Y') FOR [Enabled]
END

GO
