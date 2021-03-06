USE [dbamgnt]
GO
EXEC sys.sp_dropextendedproperty @name=N'Source' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'PROCEDURE',@level1name=N'sp_ListDatabasePermissions'

GO
EXEC sys.sp_dropextendedproperty @name=N'Description' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'PROCEDURE',@level1name=N'sp_ListDatabasePermissions'

GO
EXEC sys.sp_dropextendedproperty @name=N'Author' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'PROCEDURE',@level1name=N'sp_ListDatabasePermissions'

GO
/****** Object:  StoredProcedure [dbo].[sp_ListDatabasePermissions]    Script Date: 9/5/2017 6:13:35 AM ******/
DROP PROCEDURE [dbo].[sp_ListDatabasePermissions]
GO
/****** Object:  StoredProcedure [dbo].[sp_ListDatabasePermissions]    Script Date: 9/5/2017 6:13:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_ListDatabasePermissions]
	@DatabaseName varchar(128)
	,@GetOnlyTSQLColumn char(1) = N
AS
-- ***********************************************************************
-- Stored Procedure Name:	Audit.spr_DBM_DatabasePermissions
-- Date Created:			2011-12-07
-- By: 						Thomas Liddle
--
-- Purpose:					List of Permissions for a Database
-- 
-- Inputs:					@DatabaseName = DatabaseName
--							@GetOnlyTSQLColumn = Y|N (N=default)
--							(Used for scripting purposes)
-- Updated:
-- By:				On:			Reason:
-- Thomas Liddle	2011-12-07	Created
-- Thomas Liddle	2012-05-01	Added Object and Schema name to SELECT
-- Thomas Liddle	2012-05-01	Added the TSQL column to SELECT
-- Thomas Liddle	2012-05-01	Added @GetOnlyTSQLColumn to be used
--								to script out permissions
-- ***********************************************************************
SET NOCOUNT ON
DECLARE @sqlcmd varchar(1024)

DECLARE @DatabasePrincipals TABLE (
	name varchar(128)
	,type_desc varchar(128)
	,principal_id bigint)
	
DECLARE @DatabasePermissions TABLE(
	grantee_principal_id bigint
	,permission_name varchar(255)
	,state_desc varchar(255)
	,class_desc varchar(255)
	,SchemaName varchar(128)
	,ObjectName varchar(128)
	,ColumnName varchar(128))
	
SET @sqlcmd = 'USE [' + @DatabaseName + '] SELECT name,type_desc,principal_id FROM ' + @DatabaseName + '.sys.database_principals'
INSERT INTO @DatabasePrincipals
	EXEC(@sqlcmd)

SET @sqlcmd = 'USE [' + @DatabaseName + '] SELECT grantee_principal_id,permission_name,state_desc,class_desc,OBJECT_SCHEMA_NAME(major_id,DB_ID(''' + @DatabaseName + ''')),OBJECT_NAME(major_id,DB_ID(''' + @DatabaseName + ''')),COL_NAME(major_id,minor_id) FROM ' + @DatabaseName + '.sys.database_permissions'
INSERT INTO @DatabasePermissions
	EXEC(@sqlcmd)

IF @GetOnlyTSQLColumn = 'N'
BEGIN
	SELECT 
		@DatabaseName as 'DatabaseName'
		,dbpric.name AS 'PrincipalName'
		,dbperms.permission_name AS 'PermissionName'
		,dbpric.type_desc AS 'PrincipalType'
		,dbperms.state_desc AS 'PermissionType'
		,dbperms.class_desc AS 'ClassType'
		,dbperms.SchemaName
		,dbperms.ObjectName
		,dbperms.ColumnName
		,'TSQL' = 
			CASE	
				WHEN dbperms.class_desc = 'OJBECT_OR_COLUMN' AND dbperms.ColumnName IS NULL THEN dbperms.state_desc + ' ' + dbperms.permission_name + ' ON [' + @DatabaseName + '].[' + dbperms.SchemaName + '].' + '[' + dbperms.ObjectName + '] TO [' + dbpric.name + ']'
				WHEN dbperms.class_desc = 'DATABASE' THEN 'USE [' + @DatabaseName + '] ' + CHAR(13) + CHAR(10) + 'GO ' + CHAR(13) + CHAR(10) + dbperms.state_desc + ' ' + dbperms.permission_name + ' TO [' + dbpric.name + ']'
			ELSE
				dbperms.state_desc + ' ' + dbperms.permission_name + ' ON ' + '[' + @DatabaseName + '].['  + dbperms.SchemaName + '].' + '[' + dbperms.ObjectName + '](' + dbperms.ColumnName + ') TO [' + dbpric.name + ']'	
			END
	from @DatabasePermissions dbperms INNER JOIN @DatabasePrincipals dbpric
		ON dbperms.grantee_principal_id = dbpric.principal_id
	where dbpric.name NOT IN ('dbo','guest','public')
	and dbpric.type_desc NOT IN ('CERTIFICATE_MAPPED_USER')
	and dbpric.name NOT LIKE '##%'
	and dbperms.permission_name NOT IN ('CONNECT')
END

IF @GetOnlyTSQLColumn = 'Y'
BEGIN
	SELECT 
		'--permission' = 
			CASE	
				WHEN dbperms.class_desc = 'OJBECT_OR_COLUMN' AND dbperms.ColumnName IS NULL THEN dbperms.state_desc + ' ' + dbperms.permission_name + ' ON [' + @DatabaseName + '].[' + dbperms.SchemaName + '].' + '[' + dbperms.ObjectName + '] TO [' + dbpric.name + ']'
				WHEN dbperms.class_desc = 'DATABASE' THEN 'USE [' + @DatabaseName + '] ' + CHAR(13) + CHAR(10) + 'GO ' + CHAR(13) + CHAR(10) + dbperms.state_desc + ' ' + dbperms.permission_name + ' TO [' + dbpric.name + ']'
			ELSE
				dbperms.state_desc + ' ' + dbperms.permission_name + ' ON ' + '[' + @DatabaseName + '].['  + dbperms.SchemaName + '].' + '[' + dbperms.ObjectName + '](' + dbperms.ColumnName + ') TO [' + dbpric.name + ']'	
			END
	from @DatabasePermissions dbperms INNER JOIN @DatabasePrincipals dbpric
		ON dbperms.grantee_principal_id = dbpric.principal_id
	where dbpric.name NOT IN ('dbo','guest','public')
	and dbpric.type_desc NOT IN ('CERTIFICATE_MAPPED_USER')
	and dbpric.name NOT LIKE '##%'
	and dbperms.permission_name NOT IN ('CONNECT')

END


GO
EXEC sys.sp_addextendedproperty @name=N'Author', @value=N'Thomas Liddle' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'PROCEDURE',@level1name=N'sp_ListDatabasePermissions'
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'This procedure will list all the permissions for a SQL Login.  Used mostly for documentation and copying of a SQL Login.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'PROCEDURE',@level1name=N'sp_ListDatabasePermissions'
GO
EXEC sys.sp_addextendedproperty @name=N'Source', @value=N'http://www.thomasliddledba.com' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'PROCEDURE',@level1name=N'sp_ListDatabasePermissions'
GO
