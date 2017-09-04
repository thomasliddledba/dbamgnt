USE [dbamgnt]
GO
IF  EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'Source' , N'SCHEMA',N'dbo', N'TABLE',N'DefaultParms', NULL,NULL))
EXEC sys.sp_dropextendedproperty @name=N'Source' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DefaultParms'

GO
IF  EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'Description' , N'SCHEMA',N'dbo', N'TABLE',N'DefaultParms', NULL,NULL))
EXEC sys.sp_dropextendedproperty @name=N'Description' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DefaultParms'

GO
IF  EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'Author' , N'SCHEMA',N'dbo', N'TABLE',N'DefaultParms', NULL,NULL))
EXEC sys.sp_dropextendedproperty @name=N'Author' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DefaultParms'

GO
/****** Object:  Table [dbo].[DefaultParms]    Script Date: 9/4/2017 8:26:47 AM ******/
DROP TABLE IF EXISTS [dbo].[DefaultParms]
GO
/****** Object:  Table [dbo].[DefaultParms]    Script Date: 9/4/2017 8:26:47 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DefaultParms]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[DefaultParms](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Parm] [varchar](20) NULL,
	[Value] [varchar](128) NULL,
 CONSTRAINT [PK_DefaultParms] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'Author' , N'SCHEMA',N'dbo', N'TABLE',N'DefaultParms', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'Author', @value=N'Thomas Liddle' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DefaultParms'
GO
IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'Description' , N'SCHEMA',N'dbo', N'TABLE',N'DefaultParms', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Store Default Parameters for SQL Server Agent Jobs or for Stored Procedures.  This table must be called directly.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DefaultParms'
GO
IF NOT EXISTS (SELECT * FROM sys.fn_listextendedproperty(N'Source' , N'SCHEMA',N'dbo', N'TABLE',N'DefaultParms', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'Source', @value=N'http://www.thomasliddledba.com/' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DefaultParms'
GO
