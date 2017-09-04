USE [dbamgnt]
GO
IF  EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'Source' , N'SCHEMA',N'dbo', N'TABLE',N'CommandLog', NULL,NULL))
EXEC sys.sp_dropextendedproperty @name=N'Source' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CommandLog'

GO
IF  EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'Description' , N'SCHEMA',N'dbo', N'TABLE',N'CommandLog', NULL,NULL))
EXEC sys.sp_dropextendedproperty @name=N'Description' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CommandLog'

GO
IF  EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'Author' , N'SCHEMA',N'dbo', N'TABLE',N'CommandLog', NULL,NULL))
EXEC sys.sp_dropextendedproperty @name=N'Author' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CommandLog'

GO
/****** Object:  Table [dbo].[CommandLog]    Script Date: 9/4/2017 8:26:47 AM ******/
DROP TABLE IF EXISTS [dbo].[CommandLog]
GO
/****** Object:  Table [dbo].[CommandLog]    Script Date: 9/4/2017 8:26:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CommandLog]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CommandLog](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[DatabaseName] [sysname] NULL,
	[SchemaName] [sysname] NULL,
	[ObjectName] [sysname] NULL,
	[ObjectType] [char](2) NULL,
	[IndexName] [sysname] NULL,
	[IndexType] [tinyint] NULL,
	[StatisticsName] [sysname] NULL,
	[PartitionNumber] [int] NULL,
	[ExtendedInfo] [xml] NULL,
	[Command] [nvarchar](max) NOT NULL,
	[CommandType] [nvarchar](60) NOT NULL,
	[StartTime] [datetime] NOT NULL,
	[EndTime] [datetime] NULL,
	[ErrorNumber] [int] NULL,
	[ErrorMessage] [nvarchar](max) NULL,
 CONSTRAINT [PK_CommandLog] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'Author' , N'SCHEMA',N'dbo', N'TABLE',N'CommandLog', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'Author', @value=N'Ola Hallengren' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CommandLog'
GO
IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'Description' , N'SCHEMA',N'dbo', N'TABLE',N'CommandLog', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Support OLA Hallengren Scripts' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CommandLog'
GO
IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'Source' , N'SCHEMA',N'dbo', N'TABLE',N'CommandLog', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'Source', @value=N'https://ola.hallengren.com/' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CommandLog'
GO
