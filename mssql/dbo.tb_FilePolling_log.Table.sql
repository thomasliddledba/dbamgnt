USE [dbamgnt]
GO
/****** Object:  Table [dbo].[tb_FilePolling_log]    Script Date: 9/5/2017 6:13:35 AM ******/
DROP TABLE [dbo].[tb_FilePolling_log]
GO
/****** Object:  Table [dbo].[tb_FilePolling_log]    Script Date: 9/5/2017 6:13:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tb_FilePolling_log](
	[LogID] [int] IDENTITY(1,1) NOT NULL,
	[AppID] [char](6) NULL,
	[Status] [char](1) NULL,
	[MessageText] [varchar](max) NULL,
	[Date_Time] [datetime] NULL,
 CONSTRAINT [PK_tb_FilePolling_log] PRIMARY KEY CLUSTERED 
(
	[LogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
