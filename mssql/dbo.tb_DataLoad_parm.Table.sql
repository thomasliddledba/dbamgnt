USE [dbamgnt]
GO
ALTER TABLE [dbo].[tb_DataLoad_parm] DROP CONSTRAINT [DF_tb_DataLoad_parm_ENABLED]
GO
ALTER TABLE [dbo].[tb_DataLoad_parm] DROP CONSTRAINT [DF_tb_DataLoad_parm_BATCHSIZE]
GO
ALTER TABLE [dbo].[tb_DataLoad_parm] DROP CONSTRAINT [DF_tb_DataLoad_parm_KEEPNULLS]
GO
ALTER TABLE [dbo].[tb_DataLoad_parm] DROP CONSTRAINT [DF_tb_DataLoad_parm_KEEPIDENTITY]
GO
ALTER TABLE [dbo].[tb_DataLoad_parm] DROP CONSTRAINT [DF_tb_DataLoad_parm_LASTROW]
GO
ALTER TABLE [dbo].[tb_DataLoad_parm] DROP CONSTRAINT [DF_tb_DataLoad_parm_StartRow]
GO
/****** Object:  Table [dbo].[tb_DataLoad_parm]    Script Date: 9/5/2017 6:13:35 AM ******/
DROP TABLE [dbo].[tb_DataLoad_parm]
GO
/****** Object:  Table [dbo].[tb_DataLoad_parm]    Script Date: 9/5/2017 6:13:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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

GO
ALTER TABLE [dbo].[tb_DataLoad_parm] ADD  CONSTRAINT [DF_tb_DataLoad_parm_StartRow]  DEFAULT ((-1)) FOR [StartRow]
GO
ALTER TABLE [dbo].[tb_DataLoad_parm] ADD  CONSTRAINT [DF_tb_DataLoad_parm_LASTROW]  DEFAULT ((-1)) FOR [LASTROW]
GO
ALTER TABLE [dbo].[tb_DataLoad_parm] ADD  CONSTRAINT [DF_tb_DataLoad_parm_KEEPIDENTITY]  DEFAULT ('N') FOR [KEEPIDENTITY]
GO
ALTER TABLE [dbo].[tb_DataLoad_parm] ADD  CONSTRAINT [DF_tb_DataLoad_parm_KEEPNULLS]  DEFAULT ('N') FOR [KEEPNULLS]
GO
ALTER TABLE [dbo].[tb_DataLoad_parm] ADD  CONSTRAINT [DF_tb_DataLoad_parm_BATCHSIZE]  DEFAULT ((1000)) FOR [BATCHSIZE]
GO
ALTER TABLE [dbo].[tb_DataLoad_parm] ADD  CONSTRAINT [DF_tb_DataLoad_parm_ENABLED]  DEFAULT ('Y') FOR [ENABLED]
GO
