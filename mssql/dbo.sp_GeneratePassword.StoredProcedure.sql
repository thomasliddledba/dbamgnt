USE [dbamgnt]
GO
/****** Object:  StoredProcedure [dbo].[sp_GeneratePassword]    Script Date: 9/5/2017 6:13:35 AM ******/
DROP PROCEDURE [dbo].[sp_GeneratePassword]
GO
/****** Object:  StoredProcedure [dbo].[sp_GeneratePassword]    Script Date: 9/5/2017 6:13:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_GeneratePassword] (
	@pCount int = 1, --generate 3 passwords unless otherwise specified
	@pLength int = 15,
	@charSet int = 1, -- 2 is alphanumeric + special characters,
					 -- 1 is alphanumeric, 0 is alphabetical only
	@passwordout varchar(255) OUTPUT
)
AS
-- ***********************************************************************
-- Stored Procedure Name:	[dbo].[sp_GeneratePassword]
-- Date Created:			2013-01-18
-- By: 						Thomas Liddle
--
-- Purpose:					Generate a password
-- 
-- 
-- Updated:
-- By:				On:			Reason:
-- Thomas Liddle	2013-01-18	Created
-- ***********************************************************************
BEGIN
SET NOCOUNT ON
IF @pLength < 8 SET @pLength = 8 -- set minimum length
ELSE IF @pLength > 50 SET @pLength = 50 -- set maximum length
 
DECLARE
	@password varchar(50),
	@string varchar(72), --52 possible letters + 10 possible numbers + up to 20 possible extras
	@numbers varchar(10),
	@extra varchar(20),
	@stringlen tinyint,
	@index tinyint
 
--table variable to hold password list
DECLARE @PassList TABLE (
	[password] varchar(50)
)
 
-- eliminate 0, 1, I, l, O to make the password more readable
SET @string = 'ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz' -- option @charset = 0
SET @numbers = '23456789'
SET @extra = '>_!@#$%&=?<>' -- special characters
 
SET @string =
	CASE @charset
		WHEN 2 THEN @string + @numbers + @extra
		WHEN 1 THEN @string + @numbers
		ELSE @string
	END
 
SET @stringlen = len(@string)

DECLARE @i int
SET @i = @pLength
WHILE (@pCount > 0)
BEGIN
	SET @password = ''
	
	WHILE (@i > 0)
	BEGIN
		SET @index = (ABS(CHECKSUM(newid())) % @stringlen) + 1 --or rand()
		SET @password = @password + SUBSTRING(@string, @index, 1)
		SET @i = @i - 1 
		--SET @pLength = @pLength - 1
	END
	INSERT INTO @PassList ([password]) SELECT @password
	SET @pCount = @pCount - 1
END
SELECT @passwordout = [password] FROM @PassList
END


GO
