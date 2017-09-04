USE [dbamgnt]
GO
/****** Object:  StoredProcedure [dbo].[sp_GetWindowsLoginAuthenticationMethod]    Script Date: 9/4/2017 8:26:47 AM ******/
DROP PROCEDURE IF EXISTS [dbo].[sp_GetWindowsLoginAuthenticationMethod]
GO
/****** Object:  StoredProcedure [dbo].[sp_GetWindowsLoginAuthenticationMethod]    Script Date: 9/4/2017 8:26:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_GetWindowsLoginAuthenticationMethod]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[sp_GetWindowsLoginAuthenticationMethod] AS' 
END
GO
ALTER PROCEDURE [dbo].[sp_GetWindowsLoginAuthenticationMethod]
	@WindowsLoginName varchar(128)
AS
-- ***********************************************************************
-- Stored Procedure Name:	Audit.spr_DBM_GetWindowsLoginAuthenticationMethod
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
