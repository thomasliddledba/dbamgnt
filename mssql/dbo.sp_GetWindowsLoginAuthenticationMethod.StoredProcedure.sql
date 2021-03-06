USE [dbamgnt]
GO
EXEC sys.sp_dropextendedproperty @name=N'Source' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'PROCEDURE',@level1name=N'sp_GetWindowsLoginAuthenticationMethod'

GO
EXEC sys.sp_dropextendedproperty @name=N'Description' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'PROCEDURE',@level1name=N'sp_GetWindowsLoginAuthenticationMethod'

GO
EXEC sys.sp_dropextendedproperty @name=N'Author' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'PROCEDURE',@level1name=N'sp_GetWindowsLoginAuthenticationMethod'

GO
/****** Object:  StoredProcedure [dbo].[sp_GetWindowsLoginAuthenticationMethod]    Script Date: 9/5/2017 6:13:35 AM ******/
DROP PROCEDURE [dbo].[sp_GetWindowsLoginAuthenticationMethod]
GO
/****** Object:  StoredProcedure [dbo].[sp_GetWindowsLoginAuthenticationMethod]    Script Date: 9/5/2017 6:13:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_GetWindowsLoginAuthenticationMethod]
	@WindowsLoginName varchar(128)
AS
-- ***********************************************************************
-- Stored Procedure Name:	[dbo].[sp_GetWindowsLoginAuthenticationMethod]
-- Date Created:			2011-12-07
-- By: 						Thomas Liddle
--
-- Purpose:					List How a Windows Login authentications to 
--							a specified SQL Server.
--
--
-- Inputs:					@WindowsLoginName = Windows Users Domain Account
--							(ex.  Domain\UserID)
-- 
-- Updated:
-- By:				On:			Reason:
-- Thomas Liddle	2011-12-07	Created
-- ***********************************************************************
DECLARE @WindowsGroupMembers TABLE(
	AccountName varchar(255)
	,Type varchar(255)
	,privilege varchar(255)
	,MappedLoginName varchar(255)
	,PermissionPath varchar(255))
INSERT INTO @WindowsGroupMembers
	exec master..xp_logininfo @WindowsLoginName, 'all'
	
SELECT
	UPPER(AccountName) AS 'WindowsAccountName'
	,UPPER(privilege) as 'SQLPrivilege'
	,'AuthenticationPath' = 
		CASE
			WHEN PermissionPath IS NULL THEN UPPER('ExplicitSQLLogin')
		ELSE
			UPPER(PermissionPath)
		END
FROM @WindowsGroupMembers

GO
EXEC sys.sp_addextendedproperty @name=N'Author', @value=N'Thomas Liddle' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'PROCEDURE',@level1name=N'sp_GetWindowsLoginAuthenticationMethod'
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'This procedure will inform a DBA on how a SQL Login is authenticated.  Good for finding out which WIndows Group a user is authenticated with.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'PROCEDURE',@level1name=N'sp_GetWindowsLoginAuthenticationMethod'
GO
EXEC sys.sp_addextendedproperty @name=N'Source', @value=N'http://www.thomasliddledba.com' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'PROCEDURE',@level1name=N'sp_GetWindowsLoginAuthenticationMethod'
GO
