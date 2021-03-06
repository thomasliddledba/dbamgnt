USE [dbamgnt]
GO
/****** Object:  StoredProcedure [dbo].[sp_DataDump]    Script Date: 9/5/2017 6:13:35 AM ******/
DROP PROCEDURE [dbo].[sp_DataDump]
GO
/****** Object:  StoredProcedure [dbo].[sp_DataDump]    Script Date: 9/5/2017 6:13:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_DataDump]
	@AppID VARCHAR(MAX)
	,@ReportJobs CHAR(1) = 'N'
	,@TransactionID VARCHAR(MAX) = NULL OUTPUT
AS
SET NOCOUNT ON

--- ***************************************************************************
--- Procedure Name:		sp_DataDump
--- Date Created:		2010-03-13
--- By: 				Thomas Liddle
---
--- Purpose:			This procedure will be  used to standardize the process
---						of bcp.  Much like tabload standarizes the process for
---						BULK INSERT.
---
--- Updated:
--- By:				On:			Reason:
--- Thomas Liddle	2010-03-13	Created
--- Thomas Liddle	2010-10-21	Added column header and expression feature
--- Thomas Liddle	2010-10-22	Created additional logging information and auditing
--- Thomas Liddle	2010-12-06	Add functionailty to use parms when using stored procs
--- Thomas Liddle	2010-12-06	Created additional logging
---	Thomas Liddle	2010-12-08	Created custom header file for BCP
--- Thomas Liddle	2011-03-08	Modified custom header file code
---	Thomas Liddle	2011-07-13	Added Functionality to FTP file to FTP Server
---	Thomas Liddle	2011-07-28	Added Functionality to encrypt FTP Passwords
--- Thomas Liddle	2011-09-02	Minor Changes/Corrections to Row Terminator
--- ***************************************************************************
/*
******************************************************************************************
START:  DECLARE
******************************************************************************************
*/
DECLARE @ObjectName VARCHAR(512)
DECLARE @BackupFile CHAR(1) 
DECLARE @FieldTerminator CHAR(4) 
DECLARE @RowTerminator CHAR(4) 
DECLARE @UseCharDataType CHAR(1)
DECLARE @BatchSize INT 
DECLARE @ZipFile CHAR(1)
DECLARE @FileName VARCHAR(512)
DECLARE @DatabaseName VARCHAR(512)
DECLARE @CopyToMomOutBound CHAR(1)
DECLARE @FTPPath VARCHAR(1024)
DECLARE @SQLLogsPath VARCHAR(1024)
DECLARE @result INT
DECLARE @oscmd VARCHAR(1024)
DECLARE @FileNameOLD VARCHAR(1024)
DECLARE @Subject AS VARCHAR(512)
DECLARE @LogFile VARCHAR(512)	
DECLARE @AltLocation1 VARCHAR(MAX)
DECLARE @AltLocation2 VARCHAR(MAX)
DECLARE @FullFileLocation VARCHAR(1024)
DECLARE @ErrorInt INT
DECLARE @Enabled CHAR(1)
DECLARE @ObjectNameid INT
DECLARE @ObjectSQL NVARCHAR(255)
DECLARE @ObjectNameType NCHAR(2)
DECLARE @ParmDefinition nvarchar(500)
DECLARE @IncludeColumnHeaders CHAR(1)
DECLARE @IncludeCustomHeader CHAR(1)
DECLARE @CustomHeaderFileINT INT
DECLARE @CustomHeaderFile VARCHAR(8000)
DECLARE @column_header VARCHAR(8000)
DECLARE @TmpExpressionVariable VARCHAR(512)
DECLARE @TmpDateAdd INT
DECLARE @ExpressionDate DATETIME
DECLARE @RowTerminatorModified CHAR(4) 
DECLARE @FTPServerName VARCHAR(512)
DECLARE @FTPUserName VARCHAR(512)
DECLARE @FTPPassword VARCHAR(20)
DECLARE @FTPDirectory VARCHAR(2048)
DECLARE @FTPInd CHAR(1)
DECLARE @FTPArguments VARCHAR(2048)
DECLARE @PassPharse VARCHAR(512)
DECLARE @ColumnHeaders TABLE (
	colName VARCHAR(MAX))
DECLARE @FTPResults TABLE (
	colResults VARCHAR(MAX))
/*
******************************************************************************************
END:  DECLARE
******************************************************************************************
*/

/*
******************************************************************************************
START:  SET DEFAULTS
******************************************************************************************
*/
SET @result = 99
SET @FTPPath = (SELECT FileLocation FROM tb_DataDump_parm WHERE AppID = @AppID)
SET @TransactionID = (SELECT CAST(NEWID() AS VARCHAR(MAX)))
SET @ErrorInt = (SELECT 0) --Default 0 (No error)
SET @column_header = ''

/*
******************************************************************************************
END:  SET DEFAULTS
******************************************************************************************
*/

/*
******************************************************************************************
START:  GET ALL THE VALUES FROM THE tb_dataDump_parm
******************************************************************************************
*/
IF (SELECT COUNT(*) FROM tb_DataDump_parm WHERE AppID = @AppID) > 0
	BEGIN
		--Get PassPharse for Decryption of FTP Password
		EXEC dbo.usp_GetDataDumpPassPharse @PassphaseOUTPUT=@PassPharse OUTPUT
		
		SELECT @ObjectName = ObjectName FROM tb_DataDump_parm  WHERE [AppID] = @AppID
		SELECT @BackupFile = BackupFile FROM tb_dataDump_parm WHERE [AppID] = @AppID
		SELECT @FieldTerminator = FieldTerminator FROM tb_DataDump_parm  WHERE [AppID] = @AppID
		SELECT @RowTerminator = RowTerminator FROM tb_DataDump_parm  WHERE [AppID] = @AppID
		SELECT @BatchSize = BatchSize FROM tb_DataDump_parm  WHERE [AppID] = @AppID
		SELECT @ZipFile = ZipFile FROM tb_DataDump_parm  WHERE [AppID] = @AppID
		SELECT @FileName = FileName FROM tb_DataDump_parm  WHERE [AppID] = @AppID
		SELECT @DatabaseName = DatabaseName FROM tb_DataDump_parm  WHERE [AppID] = @AppID
		SELECT @AltLocation1 = CopyToAltLocation1 FROM tb_DataDump_parm  WHERE AppID = @AppID
		SELECT @AltLocation2 = CopyToAltLocation2 FROM tb_DataDump_parm  WHERE AppID = @AppID
		SELECT @UseCharDataType = UseCharDataType FROM tb_DataDump_parm  WHERE AppID = @AppID
		SELECT @IncludeColumnHeaders = IncludeColumnHeaders FROM tb_DataDump_parm  WHERE AppID = @AppID
		SELECT @IncludeCustomHeader = IncludeCustomHeader FROM tb_DataDump_parm  WHERE AppID = @AppID
		SELECT @FTPServerName = FTPServerName FROM tb_DataDump_parm  WHERE AppID = @AppID
		SELECT @FTPUserName = FTPUserName FROM tb_DataDump_parm  WHERE AppID = @AppID
		SELECT @FTPPassword = CONVERT(VARCHAR(8000),DECRYPTBYPASSPHRASE(@PassPharse,FTPPassword)) FROM tb_DataDump_parm  WHERE AppID = @AppID
		SELECT @FTPDirectory = FTPDirectory FROM tb_DataDump_parm  WHERE AppID = @AppID
		SELECT @FTPInd = FTPInd FROM tb_DataDump_parm  WHERE AppID = @AppID
		SELECT @FTPArguments = FTPArguments FROM tb_DataDump_parm  WHERE AppID = @AppID
		SELECT @Enabled = Enabled FROM tb_DataDump_parm  WHERE AppID = @AppID
		PRINT 'STATUS:  Using Application ID:  ' + @AppID
	END
ELSE
	BEGIN
		RAISERROR('The Application ID specified does not exist.',16,1)
		RETURN
	END
/*
******************************************************************************************
END:  GET ALL THE VALUES FROM THE tb_dataDump_parm
******************************************************************************************
*/

/*
******************************************************************************************
START:  IF THE USER SPECIFIED THE @REPORTJOBS WITH 'Y' THEN GET A LIST OF JOBS WITH
		THE APPID SPECIFIED
******************************************************************************************
*/
IF (@ReportJobs = 'Y')
	BEGIN
		DECLARE @DataDumpJobs TABLE(
			JobName VARCHAR(512)
			,AppID VARCHAR(MAX))
		INSERT INTO @DataDumpJobs
		SELECT DISTINCT
			sysjobs.name
			,RTRIM(LTRIM(SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(command,'datadump',''),'@APPID',''),'=',''),'''',''),CHARINDEX('DataDump',command),LEN(Command))))
			FROM msdb..sysjobsteps sysjobsteps INNER JOIN
			msdb..sysjobs sysjobs
			ON sysjobsteps.job_id = sysjobs.job_id
		WHERE command LIKE '%spr_DataDump%'

		SELECT * FROM @DataDumpJobs
		WHERE AppID =@AppID
		
		RETURN
	END
/*
******************************************************************************************
END:  IF THE USER SPECIFIED THE @REPORTJOBS WITH 'Y' THEN GET A LIST OF JOBS WITH
		THE APPID SPECIFIED
******************************************************************************************
*/	
/*
******************************************************************************************
START:  LOG INFORMATION TO THE tbl_DataDump_log TABLE AND CHECK TO SEE IF THE USER
		SPECIFIED THE APPID BE DISABLED
******************************************************************************************
*/
PRINT 'STATUS:  Transaction ID:  ' + @TransactionID

PRINT 'STATUS:  DATADUMP STARTED'
INSERT INTO tb_DataDump_log (
	[TransactionID],
	[AppID],
	[EventType],
	[MessageText]
) VALUES ( 
	/* TransactionID - varchar(max) */ @TransactionID,
	/* AppID - varchar(6) */ @AppID,
	/* EventType - varchar(128) */ 'BEGIN',
	/* MessageText - varchar(max) */ 'DATADUMP STARTED' )

IF (@Enabled) = 'N'
	BEGIN
		PRINT 'APPID ' + @AppID + ' is currently disabled.  This application will not run.'
		INSERT INTO tb_DataDump_log (
			[TransactionID],
			[AppID],
			[EventType],
			[MessageText]
		) VALUES ( 
			/* TransactionID - varchar(max) */ @TransactionID,
			/* AppID - varchar(6) */ @AppID,
			/* EventType - varchar(128) */ 'INFO',
			/* MessageText - varchar(max) */ 'AppID ' + @AppID + ' is currently disabled.' )
		RETURN
	END
/*
******************************************************************************************
END:  LOG INFORMATION TO THE tbl_DataDump_log TABLE AND CHECK TO SEE IF THE USER
		SPECIFIED THE APPID BE DISABLED
******************************************************************************************
*/	
/*
******************************************************************************************
START:  EXPRESSIONS.
			USAGE:
				*DATE(+/-)NUMBER! = THIS EXPRESSION IS USED TO GENERATE A DATE OTHER THEN
									THE CURRENT DATE.
									EXAMPLE:  *DATE-3! (MINUS 3 DAYS FROM CURRENT DATE)
									
				*YYYY = THIS EXPRESSION IS USED TO GENERATE A YEAR FORMAT OF (YYYY)
				*DD = THIS EXPRESSION IS USED TO GERNATE A DAY FORMAT OF (DD)
				*MM = THIS EXPRESSION IS USED TO GENERATE A MONTH FORMAT OF (MM)
				*QQ = THIS EXPRESSION IS USED TO GENERATE A QUARTER FORMAT OF (QQ)
				*WK = THIS EXPRESSION IS USED TO GENERATE A WEEK FORMAT
				*HH = THIS EXPRESSION IS USED TO GENERATE A HOUR FORMAT
				*MI = THIS EXPRESSION IS USED TO GENERATE A MINUTE FORMAT
				*SS = THIS EXPRESSION IS USED TO GENERATE A SECOND FORMAT
				*OBJECTNAME = THIS GRAB THE OBJECT NAME FROM THE OBJECT COLUMN W/O SCHEMA
******************************************************************************************
*/
SET @TmpDateAdd = NULL
SET @ExpressionDate = (SELECT GETDATE())

IF (CHARINDEX('*DATE',@FileName,1)) > 0
	BEGIN
		SET @TmpExpressionVariable = (SELECT SUBSTRING(@FileName,CHARINDEX('*DATE',@FileName),LEN(@FileName)))
		SET @TmpExpressionVariable = (SELECT SUBSTRING(@TmpExpressionVariable,1,CHARINDEX('!',@TmpExpressionVariable)))
		SET @TmpDateAdd = (SELECT SUBSTRING(REPLACE(@TmpExpressionVariable,'!',''),CHARINDEX('E',@TmpExpressionVariable) +1,LEN(@TmpExpressionVariable)))
		SET @ExpressionDate = (SELECT DATEADD(dd,@TmpDateAdd,@ExpressionDate))
		SET @FileName = REPLACE(@FileName,@TmpExpressionVariable,'')
	END

IF (CHARINDEX('*YYYY',@FileName,1)) > 0
	BEGIN
		SET @TmpExpressionVariable = (SELECT DATEPART(yy,@ExpressionDate))
		SET @FileName = REPLACE(@FileName,'*YYYY',@TmpExpressionVariable)
	END

IF (CHARINDEX('*DD',@FileName,1)) > 0
	BEGIN
		SET @TmpExpressionVariable = (SELECT DATEPART(dd,@ExpressionDate))
		SET @FileName = REPLACE(@FileName,'*DD',@TmpExpressionVariable)
	END	
	
IF (CHARINDEX('*MM',@FileName,1)) > 0
	BEGIN
		SET @TmpExpressionVariable = (SELECT DATEPART(MM,@ExpressionDate))
		SET @FileName = REPLACE(@FileName,'*MM',@TmpExpressionVariable)
	END
	
IF (CHARINDEX('*QQ',@FileName,1)) > 0
	BEGIN
		SET @TmpExpressionVariable = (SELECT DATEPART(QQ,@ExpressionDate))
		SET @FileName = REPLACE(@FileName,'*QQ',@TmpExpressionVariable)
	END

IF (CHARINDEX('*WK',@FileName,1)) > 0
	BEGIN
		SET @TmpExpressionVariable = (SELECT DATEPART(WK,@ExpressionDate))
		SET @FileName = REPLACE(@FileName,'*WK',@TmpExpressionVariable)
	END

IF (CHARINDEX('*HH',@FileName,1)) > 0
	BEGIN
		SET @TmpExpressionVariable = (SELECT DATEPART(hh,@ExpressionDate))
		SET @FileName = REPLACE(@FileName,'*HH',@TmpExpressionVariable)
	END
	
IF (CHARINDEX('*MI',@FileName,1)) > 0
	BEGIN
		SET @TmpExpressionVariable = (SELECT DATEPART(MI,@ExpressionDate))
		SET @FileName = REPLACE(@FileName,'*MI',@TmpExpressionVariable)
	END

IF (CHARINDEX('*SS',@FileName,1)) > 0
	BEGIN
		SET @TmpExpressionVariable = (SELECT DATEPART(SS,@ExpressionDate))
		SET @FileName = REPLACE(@FileName,'*SS',@TmpExpressionVariable)
	END

IF (CHARINDEX('*OBJECTNAME',@FileName,1)) > 0
	BEGIN
		SET @TmpExpressionVariable = (SELECT SUBSTRING(@ObjectName,CHARINDEX('.',@ObjectName) +1,LEN(@ObjectName)))
		SET @FileName = REPLACE(@FileName,'*OBJECTNAME',@TmpExpressionVariable)
	END
/*
******************************************************************************************
END:  EXPRESSIONS.
******************************************************************************************
*/

/*
******************************************************************************************
START:  CHECK TO SEE IF THE USER SPECIFIED TO BACKUP THE FILE
******************************************************************************************
*/

PRINT 'STATUS:  Backup File:  ' + @BackupFile

INSERT INTO tb_DataDump_log (
	[TransactionID],
	[AppID],
	[EventType],
	[MessageText]
) VALUES ( 
	/* TransactionID - varchar(max) */ @TransactionID,
	/* AppID - varchar(6) */ @AppID,
	/* EventType - varchar(128) */ 'INFO',
	/* MessageText - varchar(max) */ 'Backup File:  ' + @BackupFile )
	
IF (@BackupFile = 'Y')
	BEGIN 
		SET @result = 99 --SOMETHING OTHER THEN 0.  Most processes exit with 0 as success 
		
				SET @FileNameOLD = @FTPPath + @FileName + '.OLD'
				SELECT @oscmd = 'DEL ' + @FTPPath +  @FileName +'.OLD'
				EXEC @result = xp_cmdshell @oscmd, NO_OUTPUT
								
				IF @ZipFile = 'Y'
					BEGIN
						SELECT @oscmd = 'DEL ' + @FTPPath + '\' +  REPLACE(@FileName,SUBSTRING(@FileName,CHARINDEX('.',@FileName) + 1,10),'zip') +'.OLD'
						EXEC @result = xp_cmdshell @oscmd, NO_OUTPUT
						
						SELECT @oscmd = 'REN ' + @FTPPath + '\' +  REPLACE(@FileName,SUBSTRING(@FileName,CHARINDEX('.',@FileName) + 1,10),'zip') + ' ' + REPLACE(@FileName,SUBSTRING(@FileName,CHARINDEX('.',@FileName) + 1,10),'zip') + '.old'
						EXEC @result = xp_cmdshell @oscmd, NO_OUTPUT		
					END
				ELSE
					BEGIN
						SELECT @oscmd = 'REN ' + @FTPPath + '\' +  @FileName + ' ' + @FileName + '.old'
						EXEC @result = xp_cmdshell @oscmd, NO_OUTPUT	
					END
		END

IF (@BackupFile = 'N')
	BEGIN
		SET @result = 99 --SOMETHING OTHER THEN 0.  Most processes exit with 0 as success	
		
		SET @FileNameOLD = + @FTPPath + '\' +  @FileName
		EXEC MASTER..xp_fileexist @FileNameOLD,@result OUTPUT
		
		IF (@result = 1)
			BEGIN
				SELECT @oscmd = 'DEL ' + @FTPPath + '\' +  @FileName 
				EXEC @result = xp_cmdshell @oscmd, NO_OUTPUT
			END
	END
/*
******************************************************************************************
END:  CHECK TO SEE IF THE USER SPECIFIED TO BACKUP THE FILE
******************************************************************************************
*/
/*
******************************************************************************************
START:  FIND THE OBJECT TYPE AND CONSTRUCT THE CORRECT VERB (QUERYOUT OR OUT) FOR THE
		BCP STATEMENT
******************************************************************************************
*/
--Remove any single quotes from the object name
--this is really for users who specify parms in stored procedures
--This is temporary and the @ObjectName is reset if @ObjectNameType = P
SET @ObjectName = @ObjectName + ''''
SET @ObjectName = SUBSTRING(@ObjectName,1,CHARINDEX('''',@ObjectName) - 1)
--END

SELECT @ObjectNameID = object_id(@DatabaseName + '.' + @ObjectName)
PRINT 'STATUS:  Object Name:  ' + @DatabaseName + '.' + @ObjectName
SET @ObjectSQL = 'SELECT @ObjectNameTypeOUT = type from ' + @DatabaseName + '..sysobjects WHERE id = ' + CAST(@ObjectNameid AS VARCHAR(255))
SET @ParmDefinition = '@ObjectNameTypeOUT varchar(2) OUTPUT'

EXEC sp_executesql 
		@ObjectSQL
		,@ParmDefinition
		,@ObjectNameTypeOUT = @ObjectNameType OUTPUT

IF (@ObjectNameType) IN ('U','V')
	BEGIN
		SET @oscmd = 'BCP [' + @DatabaseName + '].' + @ObjectName + ' OUT "' + @FTPPath + '\' +  @FileName + '" '
	END
ELSE
	IF (@ObjectNameType) = 'P'
		BEGIN
			--This is where we reset the @ObjectName WITH the PARMS for the stored proc
			SELECT @ObjectName = ObjectName FROM tb_DataDump_parm  WHERE [AppID] = @AppID
			SET @oscmd = 'BCP "EXEC [' + @DatabaseName + '].' + @ObjectName + '" QUERYOUT "' + @FTPPath + '\' +  @FileName + '" '
		END
	ELSE	
		BEGIN
			INSERT INTO tb_DataDump_log (
				[TransactionID],
				[AppID],
				[EventType],
				[MessageText]
			) VALUES ( 
				/* TransactionID - varchar(max) */ @TransactionID,
				/* AppID - varchar(6) */ @AppID,
				/* EventType - varchar(128) */ 'INFO',
				/* MessageText - varchar(max) */ 'The object specified is not a table, view, or stored procedure, can not be found in the database specified, or does not follow the naming conversation "schemaname.objectname"')					
			RAISERROR('The object specified is not a table, view, or stored procedure, can not be found in the database specified, or does not follow the naming conversation "schemaname.objectname"',16,1)
			RETURN
		END
/*
******************************************************************************************
END:  FIND THE OBJECT TYPE AND CONSTRUCT THE CORRECT VERB (QUERYOUT OR OUT) FOR THE
		BCP STATEMENT
******************************************************************************************
*/	
/*
******************************************************************************************
START:  CHECK TO SEE IF THE USER SPECIFIED THE CHARACTER DATA TYPE
		THEY ALWAYS SHOULD BUT JUST IN CASE!
******************************************************************************************
*/	
IF (@UseCharDataType = 'Y')
	BEGIN
		PRINT 'STATUS:  UseCharDataType Specified.'
		SET @oscmd = @oscmd + '-c ' 
	END
ELSE
	BEGIN
		PRINT 'STATUS:  Using Native data types.'
		SET @oscmd = @oscmd + '-n '
	END
/*
******************************************************************************************
END:  CHECK TO SEE IF THE USER SPECIFIED THE CHARACTER DATA TYPE
		THEY ALWAYS SHOULD BUT JUST IN CASE!
******************************************************************************************
*/
/*
******************************************************************************************
START:	THE USER HAS THE ABILITY TO SPECIFY A ASCII NUMBER FOR THE FIELD TERMINATOR
		WE NEED TO CHECK TO SEE IF THE VALUE THE USER GAVE IS CHAR OR INT DATA TYPE
******************************************************************************************
*/
--CHECK Field Terminator for ASCII value and characters
BEGIN TRY
	SELECT CONVERT(INT,@FieldTerminator)
	SET @FieldTerminator = (SELECT CHAR(@FieldTerminator))
END TRY

BEGIN CATCH
	--DO NOTHING
END CATCH
/*
******************************************************************************************
END:	THE USER HAS THE ABILITY TO SPECIFY A ASCII NUMBER FOR THE FIELD TERMINATOR
		WE NEED TO CHECK TO SEE IF THE VALUE THE USER GAVE IS CHAR OR INT DATA TYPE
******************************************************************************************
*/

/*
******************************************************************************************
START:	PIECE TOGETHER SOME OF THE BCP STATEMENT THAT IS COMMON
******************************************************************************************
*/

SET @oscmd = @oscmd + '-S' + @@SERVERNAME + ' -T -b ' + CAST(@BatchSize AS VARCHAR(512)) + ' -o "' + @FTPPath + '\' +  @FileName + '.log"  -t "' + RTRIM(LTRIM(REPLACE(@FieldTerminator,' ',''))) + '"'

/*
******************************************************************************************
END:	PIECE TOGETHER SOME OF THE BCP STATEMENT THAT IS COMMON
******************************************************************************************
*/

/*
******************************************************************************************
START:	CHECK TO SEE IF THE ROW TERMINATOR IS A '\r', IF IT IS....REMOVE IT
		THE BCP.EXE AUTOMATICALLY ADDS THE '\r' WHEN RUNNING INTERACTIVELY!  DARN MS!
******************************************************************************************
*/
IF (SELECT CHARINDEX('\r',@RowTerminator)) > 0
	BEGIN
		IF @RowTerminator = '\r' --Added 2011-09-02
			BEGIN
				SET @oscmd = @oscmd + ' -r "' + LTRIM(RTRIM(@RowTerminator)) + '" -m 0'
			END
		ELSE
			BEGIN
				SET @RowTerminatorModified = REPLACE(REPLACE(@RowTerminator,' ',''),'\r','')
				SET @oscmd = @oscmd + ' -r "' + REPLACE(@RowTerminatorModified,' ','') + '" -m 0'
			END
	END
ELSE
	BEGIN
		SET @oscmd = @oscmd + ' -r "' + REPLACE(@RowTerminator,' ','') + '" -m 0'	
	END
/*
******************************************************************************************
END:	CHECK TO SEE IF THE ROW TERMINATOR IS A '\r', IF IT IS....REMOVE IT
		THE BCP.EXE AUTOMATICALLY ADDS THE '\r' WHEN RUNNING INTERACTIVELY!  DARN MS!
******************************************************************************************
*/
/*
******************************************************************************************
START:	LOGGING TO THE LOG TABLE
******************************************************************************************
*/

PRINT 'STATUS:  Procedure/Object being executed:  ' + @DatabaseName + '.' + @ObjectName
INSERT INTO tb_DataDump_log (
	[TransactionID],
	[AppID],
	[EventType],
	[MessageText]
) VALUES ( 
	/* TransactionID - varchar(max) */ @TransactionID,
	/* AppID - varchar(6) */ @AppID,
	/* EventType - varchar(128) */ 'INFO',
	/* MessageText - varchar(max) */ 'Procedure/ being executed:  ' + @DatabaseName + '.' + @ObjectName)					
PRINT 'STATUS:  Row Terminator: ' + REPLACE(@RowTerminator,' ','')
INSERT INTO tb_DataDump_log (
	[TransactionID],
	[AppID],
	[EventType],
	[MessageText]
) VALUES ( 
	/* TransactionID - varchar(max) */ @TransactionID,
	/* AppID - varchar(6) */ @AppID,
	/* EventType - varchar(128) */ 'INFO',
	/* MessageText - varchar(max) */ 'Row Terminator: ' + REPLACE(@RowTerminator,' ',''))				
IF (SELECT CHARINDEX('\r',@RowTerminator)) > 0
	BEGIN
		PRINT 'STATUS:  The row terminator specified in tb_dataDump_parm has a ''\r''. This will be removed from the commandline.  BCP.exe adds this automatically.'
	END	
INSERT INTO tb_DataDump_log (
	[TransactionID],
	[AppID],
	[EventType],
	[MessageText]
) VALUES ( 
	/* TransactionID - varchar(max) */ @TransactionID,
	/* AppID - varchar(6) */ @AppID,
	/* EventType - varchar(128) */ 'INFO',
	/* MessageText - varchar(max) */ 'STATUS:  The row terminator specified in tb_dataDump_parm has a ''\r''. This will be removed from the commandline.  BCP.exe adds this automatically.')
	
PRINT 'STATUS:  Field Terminator: ' + REPLACE(@FieldTerminator,' ','')
INSERT INTO tb_DataDump_log (
	[TransactionID],
	[AppID],
	[EventType],
	[MessageText]
) VALUES ( 
	/* TransactionID - varchar(max) */ @TransactionID,
	/* AppID - varchar(6) */ @AppID,
	/* EventType - varchar(128) */ 'INFO',
	/* MessageText - varchar(max) */ 'Field Terminator: ' + REPLACE(@FieldTerminator,' ',''))
PRINT 'STATUS:  Batch Size: ' + CAST(@BatchSize AS VARCHAR(512))
INSERT INTO tb_DataDump_log (
	[TransactionID],
	[AppID],
	[EventType],
	[MessageText]
) VALUES ( 
	/* TransactionID - varchar(max) */ @TransactionID,
	/* AppID - varchar(6) */ @AppID,
	/* EventType - varchar(128) */ 'INFO',
	/* MessageText - varchar(max) */ 'Batch Size: ' + CAST(@BatchSize AS VARCHAR(512)))

PRINT 'STATUS:  IncludeCustomHeader: ' + CAST(@IncludeCustomHeader AS VARCHAR(512))
INSERT INTO tb_DataDump_log (
	[TransactionID],
	[AppID],
	[EventType],
	[MessageText]
) VALUES ( 
	/* TransactionID - varchar(max) */ @TransactionID,
	/* AppID - varchar(6) */ @AppID,
	/* EventType - varchar(128) */ 'INFO',
	/* MessageText - varchar(max) */ 'IncludeCustomHeader: ' + CAST(@IncludeCustomHeader AS VARCHAR(512)))

PRINT 'STATUS:  IncludeColumnHeaders: ' + CAST(@IncludeColumnHeaders AS VARCHAR(512))
INSERT INTO tb_DataDump_log (
	[TransactionID],
	[AppID],
	[EventType],
	[MessageText]
) VALUES ( 
	/* TransactionID - varchar(max) */ @TransactionID,
	/* AppID - varchar(6) */ @AppID,
	/* EventType - varchar(128) */ 'INFO',
	/* MessageText - varchar(max) */ 'IncludeColumnHeaders: ' + CAST(@IncludeColumnHeaders AS VARCHAR(512)))

PRINT 'STATUS:  Server Name: ' + @@SERVERNAME
INSERT INTO tb_DataDump_log (
	[TransactionID],
	[AppID],
	[EventType],
	[MessageText]
) VALUES ( 
	/* TransactionID - varchar(max) */ @TransactionID,
	/* AppID - varchar(6) */ @AppID,
	/* EventType - varchar(128) */ 'INFO',
	/* MessageText - varchar(max) */ 'Server Name: ' + @@SERVERNAME)
PRINT 'STATUS:  File Name:  ' + @FTPPath + '\' +  @FileName
INSERT INTO tb_DataDump_log (
	[TransactionID],
	[AppID],
	[EventType],
	[MessageText]
) VALUES ( 
	/* TransactionID - varchar(max) */ @TransactionID,
	/* AppID - varchar(6) */ @AppID,
	/* EventType - varchar(128) */ 'INFO',
	/* MessageText - varchar(max) */ 'File Name:  ' + @FTPPath + '\' +  @FileName)
/*
******************************************************************************************
END:	LOGGING TO THE LOG TABLE
******************************************************************************************
*/
/*
******************************************************************************************
START:	EXECUTE THE BCP STATEMENT
******************************************************************************************
*/
 --CHECK TO SEE IF THE OBJECT IS A STORED PROCEDURE AND IF THE USER WANTS COLUMNHEADERS
 --IF THE OBJECT IS A PROC AND USER INDICATED THEY WANT COLUMN HEADERS RAISE AN ERROR
 --AND LET THEM KNOW THEY CAN'T DO THAT.
IF (@ObjectNameType = 'P' AND @IncludeColumnHeaders = 'Y')
	BEGIN
		INSERT INTO tb_DataDump_log (
			[TransactionID],
			[AppID],
			[EventType],
			[MessageText]
		) VALUES ( 
			/* TransactionID - varchar(max) */ @TransactionID,
			/* AppID - varchar(6) */ @AppID,
			/* EventType - varchar(128) */ 'ERROR',
			/* MessageText - varchar(max) */ 'The IncludeColumnHeader parameter can not be used with stored procedures.')
		RAISERROR('ERROR:  The IncludeColumnHeader parameter can not be used with stored procedures.',16,1)
		RETURN
	END
ELSE
	BEGIN
		PRINT 'STATUS:  Executing the following ''' + @oscmd + ''''
		INSERT INTO tb_DataDump_log (
			[TransactionID],
			[AppID],
			[EventType],
			[MessageText]
		) VALUES ( 
			/* TransactionID - varchar(max) */ @TransactionID,
			/* AppID - varchar(6) */ @AppID,
			/* EventType - varchar(128) */ 'INFO',
			/* MessageText - varchar(max) */ 'Executing the following ''' + @oscmd + '''')
		
		
		--!!!!!!THIS IS WHERE WE EXECUTE THE CONSTRUCTED BCP STATEMENT!!!!!!!
		EXEC @result = xp_cmdshell @oscmd, NO_OUTPUT
		IF (@result = 0)
			BEGIN
				PRINT 'STATUS:  BCP process completed successfully'
				INSERT INTO tb_DataDump_log (
					[TransactionID],
					[AppID],
					[EventType],
					[MessageText]
				) VALUES ( 
					/* TransactionID - varchar(max) */ @TransactionID,
					/* AppID - varchar(6) */ @AppID,
					/* EventType - varchar(128) */ 'STATUS',
					/* MessageText - varchar(max) */ 'BCP process completed successfully')
			END
		ELSE
			BEGIN
				PRINT 'STATUS:  BCP process failed see the following log for details.  "' + @FTPPath + '\' +  @FileName + '.log"'
				INSERT INTO tb_DataDump_log (
					[TransactionID],
					[AppID],
					[EventType],
					[MessageText]
				) VALUES ( 
					/* TransactionID - varchar(max) */ @TransactionID,
					/* AppID - varchar(6) */ @AppID,
					/* EventType - varchar(128) */ 'ERROR',
					/* MessageText - varchar(max) */ 'BCP process failed see the following log for details.  "' + @FTPPath + '\' + @FileName + '.log"')
					SET @ErrorInt = 1
					RAISERROR('STATUS:  BCP process failed see pervious error.',16,1)
					RETURN
			END
	END
/*
******************************************************************************************
END:	EXECUTE THE BCP STATEMENT
******************************************************************************************
*/
/*
******************************************************************************************
START:	CHECK TO SEE IF THE USER SPECIFIED THE INCLUDECUSTOMHEADER AND IF IT EXISTS
******************************************************************************************
*/
IF (@IncludeCustomHeader = 'Y')
	BEGIN
		PRINT 'STATUS:  Verify Custom Header File Exists'
		INSERT INTO tb_DataDump_log (
			[TransactionID],
			[AppID],
			[EventType],
			[MessageText]
		) VALUES ( 
			/* TransactionID - varchar(max) */ @TransactionID,
			/* AppID - varchar(6) */ @AppID,
			/* EventType - varchar(128) */ 'INFO',
			/* MessageText - varchar(max) */ 'Verify Custom Header File Exists')
	
		SET @CustomHeaderFile = REPLACE(@FTPPath + '\' + @AppID + '.customheader','\\','\')
		PRINT 'STATUS:  Using Custom Header File:  ' + @CustomHeaderFile
		
		SET @result = 99
		EXEC MASTER..xp_fileexist @CustomHeaderFile,@result OUTPUT
		
			IF (@result = 1)
				BEGIN
					SET @CustomHeaderFileINT = 1
					PRINT 'STATUS:  Custom Header File Exists'
					INSERT INTO tb_DataDump_log (
						[TransactionID],
						[AppID],
						[EventType],
						[MessageText]
					) VALUES ( 
						/* TransactionID - varchar(max) */ @TransactionID,
						/* AppID - varchar(6) */ @AppID,
						/* EventType - varchar(128) */ 'INFO',
						/* MessageText - varchar(max) */ 'Custom Header File Exists:  ' + @CustomHeaderFile)					
				END
			ELSE
				BEGIN
					RAISERROR('ERROR:  Custom Header File does not exist',16,1)
					RETURN
				END
	END
/*
******************************************************************************************
END:	CHECK TO SEE IF THE USER SPECIFIED THE INCLUDECUSTOMHEADER AND IF IT EXISTS
******************************************************************************************
*/
/*
******************************************************************************************
START:	CHECK TO SEE IF THE USER SPECIFIED THE INCLUDECOLUMNHEADERS AND EXECUTE THE 
		BCP STATEMENT
******************************************************************************************
*/
IF (@IncludeColumnHeaders = 'Y')
		BEGIN
			PRINT 'STATUS:  Generating the Header File'
			INSERT INTO tb_DataDump_log (
				[TransactionID],
				[AppID],
				[EventType],
				[MessageText]
			) VALUES ( 
				/* TransactionID - varchar(max) */ @TransactionID,
				/* AppID - varchar(6) */ @AppID,
				/* EventType - varchar(128) */ 'INFO',
				/* MessageText - varchar(max) */ 'Generating the Header File')
			
				--Find Column Headers
				SET @ObjectSQL = 'SELECT name FROM ' + @DatabaseName + '.dbo.syscolumns WHERE id = OBJECT_ID(''' + @DatabaseName + '.' + @ObjectName + ''')'
				INSERT INTO @ColumnHeaders
					EXEC(@ObjectSQL)
				
				--Generate the column headers for the object specified
				DECLARE cheader_cursor CURSOR
					FOR
						SELECT * FROM @ColumnHeaders
					OPEN cheader_cursor
					DECLARE @cheader sysname
					fetch next from cheader_cursor INTO @cheader
					WHILE (@@FETCH_STATUS <> -1)
					BEGIN
					  IF (@@FETCH_STATUS <> -2)
							BEGIN
								IF (RTRIM(LTRIM(@FieldTerminator)) = '\t')
									BEGIN
										SET @column_header = @column_header + CHAR(9) + @cheader
									END
								ELSE
									BEGIN TRY
										SELECT CONVERT(INT,@FieldTerminator)
										SET @column_header = @column_header + CHAR(@FieldTerminator) + RTRIM(@cheader)
									END TRY
									
									BEGIN CATCH
										SET @column_header = @column_header + RTRIM(LTRIM(@FieldTerminator)) + RTRIM(@cheader)
									END CATCH
							END
						
					FETCH NEXT FROM cheader_cursor INTO @cheader
						
					END
					CLOSE cheader_cursor
					DEALLOCATE cheader_cursor 
				
					--Clean up the column header
					SET @column_header = SUBSTRING(@column_header,2,LEN(@column_header))
					
					SET @oscmd = 'BCP "SELECT ''' + @column_header + '''" QUERYOUT ' + @FTPPath + '\' + @FileName + '.header -T -c -S' + @@SERVERNAME + ' -o "' + @FTPPath + '\' + @FileName + '.header.log'
					EXEC @result = xp_cmdshell @oscmd, NO_OUTPUT
							IF (@result = 0)
								BEGIN
									PRINT 'STATUS:  Header File completed successfully'
									INSERT INTO tb_DataDump_log (
										[TransactionID],
										[AppID],
										[EventType],
										[MessageText]
									) VALUES ( 
										/* TransactionID - varchar(max) */ @TransactionID,
										/* AppID - varchar(6) */ @AppID,
										/* EventType - varchar(128) */ 'STATUS',
										/* MessageText - varchar(max) */ 'Header File completed successfully')
								END
							ELSE
								BEGIN
									PRINT 'STATUS:  Header File did not complete sucessfully.'
									INSERT INTO tb_DataDump_log (
										[TransactionID],
										[AppID],
										[EventType],
										[MessageText]
									) VALUES ( 
										/* TransactionID - varchar(max) */ @TransactionID,
										/* AppID - varchar(6) */ @AppID,
										/* EventType - varchar(128) */ 'ERROR',
										/* MessageText - varchar(max) */ 'Header File did not complete sucessfully see the following log for details.  "' + @FTPPath + '\' +  @FileName + 'header.log"')
										SET @ErrorInt = 1
										RAISERROR('STATUS:  Header File did not complete sucessfully see pervious error.',16,1)
										RETURN
								END
					
					--SET THE @OSCMD VARIABLE TO VALUES THAT WILL ALWAYS BE THERE.
					SET @oscmd = 'COPY /Y /B'
								
					IF (@CustomHeaderFileINT = 1)
					BEGIN
						--INCLUDE THE CUSTOM HEADER FILE IN THE COPY COMMAND IF THE USER SPECIFIES IT.
						SET @oscmd = @oscmd + ' "' + @FTPPath + '\' + @AppID + '.customheader" + '
					END				
					
					--NOW INCLUDE THE HEADER FILE THAT CONTAINS THE COLUMN NAMES OF THE TABLE OR VIEW
					SET @oscmd = @oscmd + ' "' + @FTPPath + '\' + @FileName + '.header" + "' + @FTPPath + '\' +  @FileName + '" "' + @FTPPath + '\' + @FileName + '.tmp"'
					EXEC @result = xp_cmdshell @oscmd, NO_OUTPUT
							IF (@result = 0)
								BEGIN
									PRINT 'STATUS:  Executing the following ''' + @oscmd + ''''
									INSERT INTO tb_DataDump_log (
										[TransactionID],
										[AppID],
										[EventType],
										[MessageText]
									) VALUES ( 
										/* TransactionID - varchar(max) */ @TransactionID,
										/* AppID - varchar(6) */ @AppID,
										/* EventType - varchar(128) */ 'INFO',
										/* MessageText - varchar(max) */ 'Executing the following ''' + @oscmd + '''')
								END
							ELSE
								BEGIN
									PRINT 'STATUS:  Failed to create file ' + @FTPPath + '\' + @FileName
									INSERT INTO tb_DataDump_log (
										[TransactionID],
										[AppID],
										[EventType],
										[MessageText]
									) VALUES ( 
										/* TransactionID - varchar(max) */ @TransactionID,
										/* AppID - varchar(6) */ @AppID,
										/* EventType - varchar(128) */ 'ERROR',
										/* MessageText - varchar(max) */ 'Failed to create file ' + @FTPPath + '\' + @FileName)
										SET @ErrorInt = 1
										RAISERROR('STATUS:  Failed to create file with header file.  See Administrator',16,1)
										RETURN
								END
					-- DELETE THE HEADER LOG (NOT NEEDED) AND RENAME THE TEMP FILE TO THE FILE SPECIFIED BY THE USER
					SET @oscmd = 'DEL "' + @FTPPath + '\' + @FileName + '" "'+ @FTPPath + '\' +  @FileName + '.header" "' + @FTPPath + '\' + @FileName + '.header.log"'
					EXEC @result = xp_cmdshell @oscmd, NO_OUTPUT
					SET @oscmd = 'REN "' + @FTPPath + '\' +  @FileName + '.tmp" "' + @FileName
					EXEC @result = xp_cmdshell @oscmd, NO_OUTPUT
					PRINT 'STATUS:  Rename ' + @FileName + '.tmp to ' + @FileName
					
					PRINT 'STATUS:  File with Header created successfully'
					INSERT INTO tb_DataDump_log (
						[TransactionID],
						[AppID],
						[EventType],
						[MessageText]
					) VALUES ( 
						/* TransactionID - varchar(max) */ @TransactionID,
						/* AppID - varchar(6) */ @AppID,
						/* EventType - varchar(128) */ 'STATUS',
						/* MessageText - varchar(max) */ 'File with Header created successfully')
			END
	BEGIN
		IF (@CustomHeaderFileINT = 1)	
					BEGIN
					--SET THE @OSCMD VARIABLE TO VALUES THAT WILL ALWAYS BE THERE.
					SET @oscmd = 'COPY /Y /B'
					--INCLUDE THE CUSTOM HEADER FILE IN THE COPY COMMAND IF THE USER SPECIFIES IT.
					SET @oscmd = @oscmd + ' "' + @FTPPath + '\' + @AppID + '.customheader" + "' + @FTPPath + '\' +  @FileName + '" "' + @FTPPath + '\' + @FileName + '.tmp"'
					
					EXEC @result = xp_cmdshell @oscmd, NO_OUTPUT
						IF (@result = 0)
							BEGIN
								PRINT 'STATUS:  Executing the following ''' + @oscmd + ''''
								INSERT INTO tb_DataDump_log (
									[TransactionID],
									[AppID],
									[EventType],
									[MessageText]
								) VALUES ( 
									/* TransactionID - varchar(max) */ @TransactionID,
									/* AppID - varchar(6) */ @AppID,
									/* EventType - varchar(128) */ 'INFO',
									/* MessageText - varchar(max) */ 'Executing the following ''' + @oscmd + '''')
							END
						ELSE
							BEGIN
								PRINT 'STATUS:  Failed to create file with customheader.'
								INSERT INTO tb_DataDump_log (
									[TransactionID],
									[AppID],
									[EventType],
									[MessageText]
								) VALUES ( 
									/* TransactionID - varchar(max) */ @TransactionID,
									/* AppID - varchar(6) */ @AppID,
									/* EventType - varchar(128) */ 'ERROR',
									/* MessageText - varchar(max) */ 'STATUS:  Failed to create file with customheader.')
									SET @ErrorInt = 1
									RAISERROR('STATUS:  Failed to create file with customheader file.  See Administrator',16,1)
									RETURN
							END
						-- DELETE THE HEADER LOG (NOT NEEDED) AND RENAME THE TEMP FILE TO THE FILE SPECIFIED BY THE USER
						SET @oscmd = 'DEL "' + @FTPPath + '\'+  @FileName + '"'
						EXEC @result = xp_cmdshell @oscmd, NO_OUTPUT
						SET @oscmd = 'REN "' + @FTPPath + '\' + @FileName + '.tmp" "' + @FileName
						EXEC @result = xp_cmdshell @oscmd, NO_OUTPUT
						PRINT 'STATUS:  Rename ' + @FileName + '.tmp to ' + @FileName
					END	
	END
/*
******************************************************************************************
END:	CHECK TO SEE IF THE USER SPECIFIED THE INCLUDECOLUMNHEADERS AND EXECUTE THE 
		BCP STATEMENT
******************************************************************************************
*/
/*
******************************************************************************************
START:	ZIP THE FILE
******************************************************************************************
*/
IF (@ZipFile = 'Y')
BEGIN	
	PRINT 'STATUS:  ZIP FILE:  Y'
	INSERT INTO tb_DataDump_log (
		[TransactionID],
		[AppID],
		[EventType],
		[MessageText]
	) VALUES ( 
		/* TransactionID - varchar(max) */ @TransactionID,
		/* AppID - varchar(6) */ @AppID,
		/* EventType - varchar(128) */ 'INFO',
		/* MessageText - varchar(max) */ 'ZIP FILE:  Y')
		
	SET @FileNameOLD = + @FTPPath + '\' +  REPLACE(@FileName,SUBSTRING(@FileName,CHARINDEX('.',@FileName) + 1,10),'zip.old')

	SET @result = 99 --SOMETHING OTHER THEN 0.  Most processes exit with 0 as success
	SELECT @oscmd = 'DEL ' + @FTPPath + '\' +  @FileNameOLD
	EXEC @result = xp_cmdshell @oscmd, NO_OUTPUT
	
	SET @result = 99 --SOMETHING OTHER THEN 0.  Most processes exit with 0 as success
	SELECT @oscmd = 'REN ' + @FTPPath + '\' +  REPLACE(@FileName,SUBSTRING(@FileName,CHARINDEX('.',@FileName) + 1,10),'zip') + REPLACE(@FileName,SUBSTRING(@FileName,CHARINDEX('.',@FileName) + 1,10),'zip') + '.old'
	EXEC @result = xp_cmdshell @oscmd, NO_OUTPUT
	
	SET @oscmd = 'WZZIP ' + @FTPPath + '\' + REPLACE(@FileName,SUBSTRING(@FileName,CHARINDEX('.',@FileName) + 1,10),'zip') + ' ' + @FTPPath + '\' +  @FileName
	
	PRINT 'STATUS:  Executing the following ''' + @oscmd + ''''
	EXEC @result = xp_cmdshell @oscmd, NO_OUTPUT
	
	IF (@result = 0)
		BEGIN
			PRINT 'STATUS:  WZZIP process completed successfully'
			SET @FileName = REPLACE(@FileName,SUBSTRING(@FileName,CHARINDEX('.',@FileName) + 1,10),'zip')
			
			INSERT INTO tb_DataDump_log (
				[TransactionID],
				[AppID],
				[EventType],
				[MessageText]
			) VALUES ( 
				/* TransactionID - varchar(max) */ @TransactionID,
				/* AppID - varchar(6) */ @AppID,
				/* EventType - varchar(128) */ 'STATUS',
				/* MessageText - varchar(max) */ 'WZZIP process completed successfully')
		END
	ELSE
		BEGIN
			PRINT 'STATUS:  WZZIP process failed.'
			RAISERROR('STATUS:  WZZIP process failed.',16,1)
			INSERT INTO tb_DataDump_log (
				[TransactionID],
				[AppID],
				[EventType],
				[MessageText]
			) VALUES ( 
				/* TransactionID - varchar(max) */ @TransactionID,
				/* AppID - varchar(6) */ @AppID,
				/* EventType - varchar(128) */ 'STATUS',
				/* MessageText - varchar(max) */ 'WZZIP process failed.')
				SET @ErrorInt = @ErrorInt + 1
			RETURN
		END
END
/*
******************************************************************************************
END:	ZIP THE FILE
******************************************************************************************
*/

/*
******************************************************************************************
START:	COPY THE FILE TO A DIFFERENT LOCATION IF THE USER SPECIFIES IT
******************************************************************************************
*/
IF (@AltLocation1 IS NOT NULL)
		BEGIN
			IF (@AltLocation1 != ' ')
			 BEGIN
				SET @result = 99
				SET @FullFileLocation = @FTPPath + '\' + @FileName
				EXEC MASTER..xp_fileexist @FullFileLocation,@result OUTPUT
				IF (@result = 1)
						BEGIN
							SET @oscmd = 'COPY "' + @FullFileLocation + '" "' + @AltLocation1 + '"'
							EXEC @result = xp_cmdshell @oscmd, NO_OUTPUT
							PRINT 'STATUS:  ' + @oscmd 
							PRINT 'STATUS:  FILE has been copied TO ' + @AltLocation1
							INSERT INTO tb_DataDump_log (
								[TransactionID],
								[AppID],
								[EventType],
								[MessageText]
							) VALUES ( 
								/* TransactionID - varchar(max) */ @TransactionID,
								/* AppID - varchar(6) */ @AppID,
								/* EventType - varchar(128) */ 'STATUS',
								/* MessageText - varchar(max) */ 'FILE has been copied TO ' + @AltLocation1)
						END
			 END
		END

IF (@AltLocation2 IS NOT NULL)
		BEGIN
			IF (@AltLocation2 != ' ')
			 BEGIN
				SET @result = 99
				SET @FullFileLocation = @FTPPath + '\' + @FileName
				EXEC MASTER..xp_fileexist @FullFileLocation,@result OUTPUT
				IF (@result = 1)
						BEGIN
							SET @oscmd = 'COPY "' + @FullFileLocation + '" "' + @AltLocation2 + '"'
							EXEC @result = xp_cmdshell @oscmd, NO_OUTPUT
							PRINT 'STATUS:  ' + @oscmd 
							PRINT 'STATUS:  FILE has been copied TO ' + @AltLocation2
							INSERT INTO tb_DataDump_log (
								[TransactionID],
								[AppID],
								[EventType],
								[MessageText]
							) VALUES ( 
								/* TransactionID - varchar(max) */ @TransactionID,
								/* AppID - varchar(6) */ @AppID,
								/* EventType - varchar(128) */ 'STATUS',
								/* MessageText - varchar(max) */ 'FILE has been copied TO ' + @AltLocation2)
						END
			 END
		END

/*
******************************************************************************************
END:	COPY THE FILE TO A DIFFERENT LOCATION IF THE USER SPECIFIES IT
******************************************************************************************
*/


/*
******************************************************************************************
START:	COPY THE FILE TO A FTP SERVER
******************************************************************************************
*/
IF (@FTPInd = 'Y')
BEGIN
	SET @result = 99
	SET @FullFileLocation = @FTPPath + '\' + @FileName
	EXEC MASTER..xp_fileexist @FullFileLocation,@result OUTPUT
	IF (@result = 1)
			BEGIN
				PRINT 'STATUS:  Generating FTP command file'
				INSERT INTO tb_DataDump_log (
					[TransactionID],
					[AppID],
					[EventType],
					[MessageText]
				) VALUES ( 
					/* TransactionID - varchar(max) */ @TransactionID,
					/* AppID - varchar(6) */ @AppID,
					/* EventType - varchar(128) */ 'STATUS',
					/* MessageText - varchar(max) */ 'STATUS:  Generating FTP command file')
				SET @oscmd = 'DEL /F /Q ' + @FTPPath + '\' + '\ftpfile' + @AppID + '.tmp'
				EXEC @result = xp_cmdshell @oscmd, NO_OUTPUT
				
				SET @oscmd = 'ECHO open ' + @FTPServername + '>>' + @FTPPath + '\' + '\ftpfile' + @AppID + '.tmp'
				EXEC @result = xp_cmdshell @oscmd, NO_OUTPUT
				
				SET @oscmd = 'ECHO ' + @FTPUserName + '>>' + @FTPPath + '\' + '\ftpfile' + @AppID + '.tmp'
				EXEC @result = xp_cmdshell @oscmd, NO_OUTPUT
				
				SET @oscmd = 'ECHO ' + @FTPPassword + '>>' + @FTPPath + '\' + '\ftpfile' + @AppID + '.tmp'
				EXEC @result = xp_cmdshell @oscmd, NO_OUTPUT
				
				SET @oscmd = 'ECHO ' + @FTPArguments + '>>' + @FTPPath + '\' + '\ftpfile' + @AppID + '.tmp'
				EXEC @result = xp_cmdshell @oscmd, NO_OUTPUT
				
				SET @oscmd = 'ECHO put ' + @FullFileLocation + ' ' + @FTPDirectory + '/' + @FileName + '>>' + @FTPPath + '\' + '\ftpfile' + @AppID + '.tmp'
				EXEC @result = xp_cmdshell @oscmd, NO_OUTPUT

				SET @oscmd = 'ECHO BYE' + '>>' + @FTPPath + '\' + '\ftpfile' + @AppID + '.tmp'
				EXEC @result = xp_cmdshell @oscmd, NO_OUTPUT
				
				SET @oscmd = 'FTP -s:' + @FTPPath + '\' +'\ftpfile' + @AppID + '.tmp '
				PRINT 'STATUS:  FTP command being processed:  ' + @oscmd
				SET @result = 0
				
				INSERT INTO @FTPResults
				EXEC xp_cmdshell @oscmd

				SELECT * FROM @FTPResults
								
				--Loop thru results of FTP command and find any errors
				DECLARE ftperror_cursor CURSOR
					FOR
					  SELECT colResults FROM @FTPResults
					OPEN ftperror_cursor
					DECLARE @errors VARCHAR(2048)
					fetch next from ftperror_cursor INTO @errors
					WHILE (@@FETCH_STATUS <> -1)
					BEGIN
					  IF (@@FETCH_STATUS <> -2)
						BEGIN
							SET NOCOUNT ON
						
							SET @result = 0
						
							IF (SELECT COUNT(colResults) FROM @FTPResults WHERE colResults LIKE '%UNKNOWN HOST%') >= 1
								BEGIN
									SET @result = @result + 1
									PRINT 'ERROR: FTP Host ''' + @FTPServerName + ''' is unknown or not available.'
									INSERT INTO tb_DataDump_log (
										[TransactionID],
										[AppID],
										[EventType],
										[MessageText]
									) VALUES ( 
										/* TransactionID - varchar(max) */ @TransactionID,
										/* AppID - varchar(6) */ @AppID,
										/* EventType - varchar(128) */ 'ERROR',
										/* MessageText - varchar(max) */ 'FTP Host ''' + @FTPServerName + ''' is unknown or not available.')
								END
								
							IF (SELECT COUNT(colResults) FROM @FTPResults WHERE colResults LIKE '%Login Failed%') >= 1
								BEGIN
									SET @result = @result + 1
									PRINT 'ERROR:  The UserName or Password for FTP Host ''' + @FTPServerName + ''' is incorrect.'
									INSERT INTO tb_DataDump_log (
										[TransactionID],
										[AppID],
										[EventType],
										[MessageText]
									) VALUES ( 
										/* TransactionID - varchar(max) */ @TransactionID,
										/* AppID - varchar(6) */ @AppID,
										/* EventType - varchar(128) */ 'ERROR',
										/* MessageText - varchar(max) */ 'The UserName or Password for FTP Host ''' + @FTPServerName + ''' is incorrect.')
								END
							
							IF (SELECT COUNT(colResults) FROM @FTPResults WHERE colResults LIKE '%The system cannot find the path specified.%') >= 1
								BEGIN
									SET @result = @result + 1
									PRINT 'ERROR:  The ftp directory ''' + @FTPDirectory + ''' does not exist or access is denied on FTP Host ''' + @FTPServerName + ''''
									INSERT INTO tb_DataDump_log (
										[TransactionID],
										[AppID],
										[EventType],
										[MessageText]
									) VALUES ( 
										/* TransactionID - varchar(max) */ @TransactionID,
										/* AppID - varchar(6) */ @AppID,
										/* EventType - varchar(128) */ 'ERROR',
										/* MessageText - varchar(max) */ 'The ftp directory ''' + @FTPDirectory + ''' does not exist or access is denied on FTP Host ''' + @FTPServerName + '''')
								END
								
							IF (SELECT COUNT(colResults) FROM @FTPResults WHERE colResults LIKE '%command not understood%') >= 1
								BEGIN
									SET @result = @result + 1
									PRINT 'ERROR:  The FTP Server did not understand the FTP Argument specified for APPID ' + @AppID
									INSERT INTO tb_DataDump_log (
										[TransactionID],
										[AppID],
										[EventType],
										[MessageText]
									) VALUES ( 
										/* TransactionID - varchar(max) */ @TransactionID,
										/* AppID - varchar(6) */ @AppID,
										/* EventType - varchar(128) */ 'ERROR',
										/* MessageText - varchar(max) */ 'The FTP Server did not understand the FTP Argument specified for APPID ' + @AppID)
								END
							IF @result > 0
								BEGIN
									RAISERROR('Error occured in the FTP process.  See tbl_DataDump_log for more details.',16,1)
									BREAK
								END
						FETCH NEXT FROM ftperror_cursor INTO @errors	
					END
					END
					CLOSE ftperror_cursor
					DEALLOCATE ftperror_cursor


				IF @result = 0
					BEGIN
						PRINT 'STATUS:  FTP Process Completed Successfully.'
						INSERT INTO tb_DataDump_log (
							[TransactionID],
							[AppID],
							[EventType],
							[MessageText]
						) VALUES ( 
							/* TransactionID - varchar(max) */ @TransactionID,
							/* AppID - varchar(6) */ @AppID,
							/* EventType - varchar(128) */ 'ERROR',
							/* MessageText - varchar(max) */ 'FTP Process Completed Successfully.')
					END

				-- Delete remaining *.tmp file
				SET @oscmd = 'DEL /F /Q ' + @FTPPath + '\' + '\ftpfile' + @AppID + '.tmp'
				EXEC @result = xp_cmdshell @oscmd
			END
END
/*
******************************************************************************************
START:	COPY THE FILE TO A FTP SERVER
******************************************************************************************
*/

PRINT 'STATUS:  DataDump END'
INSERT INTO tb_DataDump_log (
	[TransactionID],
	[AppID],
	[EventType],
	[MessageText]
) VALUES ( 
	/* TransactionID - varchar(max) */ @TransactionID,
	/* AppID - varchar(6) */ @AppID,
	/* EventType - varchar(128) */ 'END',
	/* MessageText - varchar(max) */ 'DataDump END' )


GO
