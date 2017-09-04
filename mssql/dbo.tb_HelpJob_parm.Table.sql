USE [dbamgnt]
GO
/****** Object:  Table [dbo].[tb_HelpJob_parm]    Script Date: 9/4/2017 8:26:47 AM ******/
DROP TABLE IF EXISTS [dbo].[tb_HelpJob_parm]
GO
/****** Object:  Table [dbo].[tb_HelpJob_parm]    Script Date: 9/4/2017 8:26:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tb_HelpJob_parm]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tb_HelpJob_parm](
	[App_ID] [char](6) NOT NULL,
	[Job_Name] [varchar](128) NULL,
	[StartJob] [char](1) NULL,
	[WaitToComplete] [char](1) NULL,
	[StartJobStepNum] [int] NULL,
	[Enabled] [char](1) NULL,
 CONSTRAINT [PK_tb_HelpJob_parm] PRIMARY KEY CLUSTERED 
(
	[App_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
