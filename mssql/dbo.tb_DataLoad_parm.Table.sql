USE [dbamgnt]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tb_DataLoad_parm]') AND type in (N'U'))
ALTER TABLE [dbo].[tb_DataLoad_parm] DROP CONSTRAINT IF EXISTS [DF_tb_DataLoad_parm_ENABLED]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tb_DataLoad_parm]') AND type in (N'U'))
ALTER TABLE [dbo].[tb_DataLoad_parm] DROP CONSTRAINT IF EXISTS [DF_tb_DataLoad_parm_BATCHSIZE]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tb_DataLoad_parm]') AND type in (N'U'))
ALTER TABLE [dbo].[tb_DataLoad_parm] DROP CONSTRAINT IF EXISTS [DF_tb_DataLoad_parm_KEEPNULLS]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tb_DataLoad_parm]') AND type in (N'U'))
ALTER TABLE [dbo].[tb_DataLoad_parm] DROP CONSTRAINT IF EXISTS [DF_tb_DataLoad_parm_KEEPIDENTITY]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tb_DataLoad_parm]') AND type in (N'U'))
ALTER TABLE [dbo].[tb_DataLoad_parm] DROP CONSTRAINT IF EXISTS [DF_tb_DataLoad_parm_LASTROW]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tb_DataLoad_parm]') AND type in (N'U'))
ALTER TABLE [dbo].[tb_DataLoad_parm] DROP CONSTRAINT IF EXISTS [DF_tb_DataLoad_parm_StartRow]
GO
/****** Object:  Table [dbo].[tb_DataLoad_parm]    Script Date: 9/4/2017 8:26:47 AM ******/
DROP TABLE IF EXISTS [dbo].[tb_DataLoad_parm]
GO
/****** Object:  Table [dbo].[tb_DataLoad_parm]    Script Date: 9/4/2017 8:26:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tb_DataLoad_parm]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tb_DataLoad_parm](
	[AppID] [char](6) NOT NULL,
	[PollFileAppID] [char](6) NULL,
	[SourceFileLocation] [varchar](2048) NULL,
	[DestinationDatabaseName] [varchar](128) NOT NULL,
	[DestinationTableName] [varchar](128) NOT NULL,
	[TruncateDestinationTable] [char](1) NOT NULL,
	[FormatFileLocation] [varchar](255) NOT NULL,
	[StartRow] [int] NOT NULL,
	[LASTROW] [int] NOT NULL,
	[KEEPIDENTITY] [char](1) NOT NULL,
	[KEEPNULLS] [char](1) NOT NULL,
	[BATCHSIZE] [int] NOT NULL,
	[ENABLED] [char](1) NOT NULL,
 CONSTRAINT [PK_tb_DataLoad_parm] PRIMARY KEY CLUSTERED 
(
	[AppID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_tb_DataLoad_parm_StartRow]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tb_DataLoad_parm] ADD  CONSTRAINT [DF_tb_DataLoad_parm_StartRow]  DEFAULT ((-1)) FOR [StartRow]
END

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_tb_DataLoad_parm_LASTROW]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tb_DataLoad_parm] ADD  CONSTRAINT [DF_tb_DataLoad_parm_LASTROW]  DEFAULT ((-1)) FOR [LASTROW]
END

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_tb_DataLoad_parm_KEEPIDENTITY]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tb_DataLoad_parm] ADD  CONSTRAINT [DF_tb_DataLoad_parm_KEEPIDENTITY]  DEFAULT ('N') FOR [KEEPIDENTITY]
END

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_tb_DataLoad_parm_KEEPNULLS]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tb_DataLoad_parm] ADD  CONSTRAINT [DF_tb_DataLoad_parm_KEEPNULLS]  DEFAULT ('N') FOR [KEEPNULLS]
END

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_tb_DataLoad_parm_BATCHSIZE]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tb_DataLoad_parm] ADD  CONSTRAINT [DF_tb_DataLoad_parm_BATCHSIZE]  DEFAULT ((1000)) FOR [BATCHSIZE]
END

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_tb_DataLoad_parm_ENABLED]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tb_DataLoad_parm] ADD  CONSTRAINT [DF_tb_DataLoad_parm_ENABLED]  DEFAULT ('Y') FOR [ENABLED]
END

GO
