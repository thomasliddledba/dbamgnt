USE [dbamgnt]
GO
EXEC sys.sp_dropextendedproperty @name=N'Source' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'PROCEDURE',@level1name=N'sp_hexadecimal'

GO
EXEC sys.sp_dropextendedproperty @name=N'Description' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'PROCEDURE',@level1name=N'sp_hexadecimal'

GO
EXEC sys.sp_dropextendedproperty @name=N'Author' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'PROCEDURE',@level1name=N'sp_hexadecimal'

GO
/****** Object:  StoredProcedure [dbo].[sp_hexadecimal]    Script Date: 9/5/2017 6:13:35 AM ******/
DROP PROCEDURE [dbo].[sp_hexadecimal]
GO
/****** Object:  StoredProcedure [dbo].[sp_hexadecimal]    Script Date: 9/5/2017 6:13:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_hexadecimal] 
@binvalue varbinary(256), 
@hexvalue varchar(256) OUTPUT 
AS 
DECLARE @charvalue varchar(256) 
DECLARE @i int 
DECLARE @length int 
DECLARE @hexstring char(16) 
SELECT @charvalue = '0x' 
SELECT @i = 1 
SELECT @length = DATALENGTH (@binvalue) 
SELECT @hexstring = '0123456789ABCDEF' 
WHILE (@i <= @length) 
BEGIN 
DECLARE @tempint int 
DECLARE @firstint int 
DECLARE @secondint int 
SELECT @tempint = CONVERT(int, SUBSTRING(@binvalue,@i,1)) 
SELECT @firstint = FLOOR(@tempint/16) 
SELECT @secondint = @tempint - (@firstint*16) 
SELECT @charvalue = @charvalue + 
SUBSTRING(@hexstring, @firstint+1, 1) + 
SUBSTRING(@hexstring, @secondint+1, 1) 
SELECT @i = @i + 1 
END 
SELECT @hexvalue = @charvalue 

GO
EXEC sys.sp_addextendedproperty @name=N'Author', @value=N'Microsoft' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'PROCEDURE',@level1name=N'sp_hexadecimal'
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Transfer logins and passwords between instances of SQL Server that are running older versions of SQL Server' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'PROCEDURE',@level1name=N'sp_hexadecimal'
GO
EXEC sys.sp_addextendedproperty @name=N'Source', @value=N'https://support.microsoft.com/en-us/help/246133' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'PROCEDURE',@level1name=N'sp_hexadecimal'
GO
