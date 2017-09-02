USE [master]
GO
/****** Object:  Database [dbamgnt]    Script Date: 9/2/2017 7:39:15 AM ******/
IF DB_ID('dbamgnt') IS NULL
	EXEC ('CREATE DATABASE [dbamgnt]')

GO
USE [dbamgnt]
GO
EXEC [dbamgnt].sys.sp_addextendedproperty @name=N'Version', @value=N'1.7.4' 
GO
EXEC [dbamgnt].sys.sp_addextendedproperty @name=N'Description', @value=N'A database with a collection of procedures from award winning and industry leading DBA''s focused on Database Administration and Optimization.' 
GO
EXEC [dbamgnt].sys.sp_addextendedproperty @name=N'Author', @value=N'Thomas Liddle' 
GO