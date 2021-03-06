USE [dbamgnt]
GO
ALTER TABLE [dbo].[tb_DataDump_parm] DROP CONSTRAINT [DF_tb_DataDump_parm_Enabled]
GO
ALTER TABLE [dbo].[tb_DataDump_parm] DROP CONSTRAINT [DF_tb_DataDump_parm_FTPDirectory]
GO
ALTER TABLE [dbo].[tb_DataDump_parm] DROP CONSTRAINT [DF_tb_DataDump_parm_FTPInd]
GO
ALTER TABLE [dbo].[tb_DataDump_parm] DROP CONSTRAINT [DF_tb_DataDump_parm_BatchSize]
GO
ALTER TABLE [dbo].[tb_DataDump_parm] DROP CONSTRAINT [DF_tb_DataDump_parm_IncludeCustomerHeader]
GO
ALTER TABLE [dbo].[tb_DataDump_parm] DROP CONSTRAINT [DF_tb_DataDump_parm_IncludeColumnHeaders]
GO
ALTER TABLE [dbo].[tb_DataDump_parm] DROP CONSTRAINT [DF_tb_DataDump_parm_UseCharDataType]
GO
ALTER TABLE [dbo].[tb_DataDump_parm] DROP CONSTRAINT [DF_tb_DataDump_parm_RowTerminator]
GO
ALTER TABLE [dbo].[tb_DataDump_parm] DROP CONSTRAINT [DF_tb_DataDump_parm_FieldTerminator]
GO
/****** Object:  Table [dbo].[tb_DataDump_parm]    Script Date: 9/5/2017 6:13:35 AM ******/
DROP TABLE [dbo].[tb_DataDump_parm]
GO
/****** Object:  Table [dbo].[tb_DataDump_parm]    Script Date: 9/5/2017 6:13:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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

GO
ALTER TABLE [dbo].[tb_DataDump_parm] ADD  CONSTRAINT [DF_tb_DataDump_parm_FieldTerminator]  DEFAULT ('\t') FOR [FieldTerminator]
GO
ALTER TABLE [dbo].[tb_DataDump_parm] ADD  CONSTRAINT [DF_tb_DataDump_parm_RowTerminator]  DEFAULT ('\r\n') FOR [RowTerminator]
GO
ALTER TABLE [dbo].[tb_DataDump_parm] ADD  CONSTRAINT [DF_tb_DataDump_parm_UseCharDataType]  DEFAULT ('Y') FOR [UseCharDataType]
GO
ALTER TABLE [dbo].[tb_DataDump_parm] ADD  CONSTRAINT [DF_tb_DataDump_parm_IncludeColumnHeaders]  DEFAULT ('N') FOR [IncludeColumnHeaders]
GO
ALTER TABLE [dbo].[tb_DataDump_parm] ADD  CONSTRAINT [DF_tb_DataDump_parm_IncludeCustomerHeader]  DEFAULT ('N') FOR [IncludeCustomHeader]
GO
ALTER TABLE [dbo].[tb_DataDump_parm] ADD  CONSTRAINT [DF_tb_DataDump_parm_BatchSize]  DEFAULT ((1000)) FOR [BatchSize]
GO
ALTER TABLE [dbo].[tb_DataDump_parm] ADD  CONSTRAINT [DF_tb_DataDump_parm_FTPInd]  DEFAULT ('N') FOR [FTPInd]
GO
ALTER TABLE [dbo].[tb_DataDump_parm] ADD  CONSTRAINT [DF_tb_DataDump_parm_FTPDirectory]  DEFAULT (' ') FOR [FTPDirectory]
GO
ALTER TABLE [dbo].[tb_DataDump_parm] ADD  CONSTRAINT [DF_tb_DataDump_parm_Enabled]  DEFAULT ('Y') FOR [Enabled]
GO
