use dbamgnt
go
if (select count(parm) from dbo.defaultparms where parm='BackupDirectory') = 0
	begin
		insert into dbo.defaultparms
			select 'BackupDirectory','Z:\SQLBackup'
	end

if (select count(parm) from dbo.defaultparms where parm='LogToTable') = 0
	begin
		insert into dbo.defaultparms
			select 'LogToTable','Y'
	end