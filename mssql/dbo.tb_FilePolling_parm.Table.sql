USE [dbamgnt]
GO
/****** Object:  Table [dbo].[tb_FilePolling_parm]    Script Date: 9/4/2017 8:26:47 AM ******/
DROP TABLE IF EXISTS [dbo].[tb_FilePolling_parm]
GO
/****** Object:  Table [dbo].[tb_FilePolling_parm]    Script Date: 9/4/2017 8:26:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tb_FilePolling_parm]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tb_FilePolling_parm](
	[AppID] [char](6) NOT NULL,
	[FileName] [varchar](255) NOT NULL,
	[FileLocation] [varchar](1024) NOT NULL,
	[Description] [varchar](4096) NULL,
	[StopTime] [varchar](8) NULL,
	[LastStatus] [char](1) NULL,
	[LastStatusDateTime] [datetime] NULL,
	[LastStatusDescription] [varchar](4096) NULL,
 CONSTRAINT [PK_tb_FilePolling_parm] PRIMARY KEY CLUSTERED 
(
	[AppID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
