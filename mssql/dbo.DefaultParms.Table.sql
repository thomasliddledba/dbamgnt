USE [dbamgnt]
GO
EXEC sys.sp_dropextendedproperty @name=N'Source' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DefaultParms'

GO
EXEC sys.sp_dropextendedproperty @name=N'Description' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DefaultParms'

GO
EXEC sys.sp_dropextendedproperty @name=N'Author' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DefaultParms'

GO
/****** Object:  Table [dbo].[DefaultParms]    Script Date: 9/5/2017 6:13:35 AM ******/
DROP TABLE [dbo].[DefaultParms]
GO
/****** Object:  Table [dbo].[DefaultParms]    Script Date: 9/5/2017 6:13:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DefaultParms](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Parm] [varchar](20) NULL,
	[Value] [varchar](128) NULL,
 CONSTRAINT [PK_DefaultParms] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
EXEC sys.sp_addextendedproperty @name=N'Author', @value=N'Thomas Liddle' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DefaultParms'
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Store Default Parameters for SQL Server Agent Jobs or for Stored Procedures.  This table must be called directly.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DefaultParms'
GO
EXEC sys.sp_addextendedproperty @name=N'Source', @value=N'http://www.thomasliddledba.com/' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DefaultParms'
GO
