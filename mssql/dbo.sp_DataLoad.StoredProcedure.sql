USE [dbamgnt]
GO
/****** Object:  StoredProcedure [dbo].[sp_DataLoad]    Script Date: 9/5/2017 6:13:35 AM ******/
DROP PROCEDURE [dbo].[sp_DataLoad]
GO
/****** Object:  StoredProcedure [dbo].[sp_DataLoad]    Script Date: 9/5/2017 6:13:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_DataLoad]
	@AppID CHAR(6)
AS
SET NOCOUNT ON

DECLARE @PollFileAppID CHAR(6)	
DECLARE @SourceFileLocation VARCHAR(2048)
DECLARE @DestinationDatabaseName VARCHAR(128)
DECLARE @TruncateDestinationTable CHAR(1)
DECLARE @DestinationTableName VARCHAR(128)
DECLARE @FormatFileLocation VARCHAR(255)
DECLARE @StartRow INT
DECLARE @LastRow INT
DECLARE @KEEPIDENTITY CHAR(1)
DECLARE @KeepNulls CHAR(1)
DECLARE @BatchSize INT
DECLARE @Enabled CHAR(1)
DECLARE @ErrorLogLocation VARCHAR(255)
DECLARE @FileName VARCHAR(255)
DECLARE @sqlcmd VARCHAR(MAX)
DECLARE @oscmd VARCHAR(2048)
DECLARE @result INT

SELECT @PollFileAppID = PollFileAppID FROM tb_DataLoad_parm AS TB WHERE TB.AppID = @AppID
SELECT @SourceFileLocation = SourceFileLocation FROM tb_DataLoad_parm AS TB WHERE TB.AppID = @AppID
SELECT @DestinationDatabaseName = DestinationDatabaseName FROM tb_DataLoad_parm AS TB WHERE TB.AppID = @AppID
SELECT @DestinationTableName = DestinationTableName FROM tb_DataLoad_parm AS TB WHERE TB.AppID = @AppID
SELECT @FormatFileLocation = FormatFileLocation FROM tb_DataLoad_parm AS TB WHERE TB.AppID = @AppID
SELECT @TruncateDestinationTable = TruncateDestinationTable FROM tb_DataLoad_parm AS TB WHERE TB.AppID = @AppID
SELECT @StartRow = StartRow FROM tb_DataLoad_parm AS TB WHERE TB.AppID = @AppID
SELECT @LastRow = LASTROW FROM tb_DataLoad_parm AS TB WHERE TB.AppID = @AppID
SELECT @KEEPIDENTITY = KEEPIDENTITY FROM tb_DataLoad_parm AS TB WHERE TB.AppID = @AppID
SELECT @KEEPNULLS = KEEPIDENTITY FROM tb_DataLoad_parm AS TB WHERE TB.AppID = @AppID
SELECT @BatchSize = BATCHSIZE FROM tb_DataLoad_parm AS TB WHERE TB.AppID = @AppID
SELECT @Enabled = ENABLED FROM tb_DataLoad_parm AS TB WHERE TB.AppID = @AppID

IF @Enabled NOT IN ('Y')
	BEGIN
		SELECT 'The APPID specified is not enabled'
		RETURN
	END


IF @PollFileAppID IS NOT NULL
	BEGIN
		SELECT @SourceFileLocation = FileLocation + '\' + FILENAME
										FROM dbo.tb_FilePolling_parm WHERE AppID = @PollFileAppID
										AND LastStatus = 'C'
		PRINT 'New File' + @SourceFileLocation
		IF @SourceFileLocation = ''
			BEGIN
				RAISERROR('The AppID does not exist in tb_filepoll.',16,1)
			END
	END
	
EXEC sys.xp_fileexist @SourceFileLocation,@result OUTPUT
IF @result = 0
	BEGIN
		RAISERROR('The source file specified does not exist',16,1)
		RETURN	
	END
ELSE
	BEGIN
		SET @oscmd = 'DEL /F /Q ' + @SourceFileLocation + '.processed'
		EXEC sys.xp_cmdshell @oscmd, NO_OUTPUT
	END
	
	
EXEC sys.xp_fileexist @FormatFileLocation, @result OUTPUT
IF @result = 0
	BEGIN
		RAISERROR('The format file specified does not exist',16,1)
		RETURN	
	END
	
SELECT @result = COUNT(NAME) FROM master.sys.databases AS D	WHERE d.name = @DestinationDatabaseName
IF @result = 0
	BEGIN
		RAISERROR('The destination database does not exist on the server specified.',16,1)
		RETURN
	END

IF @TruncateDestinationTable = 'Y'
	BEGIN
		PRINT 'Truncate Table ' + @DestinationDatabaseName + '.' + @DestinationTableName
		SET @sqlcmd = 'TRUNCATE TABLE ' + @DestinationDatabaseName + '.' + @DestinationTableName
		EXEC (@sqlcmd)	
	END
	
SET @sqlcmd = 'BULK INSERT ' + @DestinationDatabaseName + '.' + @DestinationTableName + ' FROM ' + '''' + @SourceFileLocation + '''' +
				' WITH ( FORMATFILE=''' + @FormatFileLocation + ''''

IF @StartRow > 0 
	BEGIN
		SET @sqlcmd = @sqlcmd + ',FIRSTROW=' + CONVERT(VARCHAR(20),@StartRow)
	END
	
IF @LastRow > 0 
	BEGIN
		SET @sqlcmd = @sqlcmd + ',LASTROW=' + CONVERT(VARCHAR(20),@LastRow)
	END
	
IF @KEEPIDENTITY = 'Y'
	BEGIN
		SET @sqlcmd = @sqlcmd + ',KEEPIDENTITY'
	END

IF @KeepNulls = 'Y'
	BEGIN
		SET @sqlcmd = @sqlcmd + ',KEEPNULLS'
	END
IF @BatchSize > 0
	BEGIN
		SET @sqlcmd = @sqlcmd + ',BATCHSIZE=' + CONVERT(VARCHAR(20), @BatchSize)
	END
	

SET @ErrorLogLocation = REVERSE(SUBSTRING(REVERSE(@FormatFileLocation),CHARINDEX('.',REVERSE(@FormatFileLocation)),LEN(@FormatFileLocation)))

SET @sqlcmd = @sqlcmd + ',MAXERRORS=3,TABLOCK,ERRORFILE=''' + @ErrorLogLocation + REPLACE(REPLACE(REPLACE(CONVERT(VARCHAR(255),GETDATE(),127),':','T'),'-','T'),'.','T') + '.err'')'


EXEC sys.xp_fileexist @SourceFileLocation,@result OUTPUT
IF @result = 0
	BEGIN
		RAISERROR('The file specified does not exist',16,1)
		RETURN	
	END
ELSE
	BEGIN
		PRINT @sqlcmd
		EXEC (@sqlcmd)

	END


SET @FileName = REVERSE(SUBSTRING(REVERSE(@SourceFileLocation),1,CHARINDEX('\',REVERSE(@SourceFileLocation)) - 1))
SET @oscmd = 'REN ' + @SourceFileLocation + ' ' + @FileName + '.processed'
PRINT @oscmd
EXEC @result = sys.xp_cmdshell @oscmd, NO_OUTPUT

IF (@result <> 0)
   BEGIN
		RAISERROR('Error occured with renaming the file to .old',16,1)
   END


GO
