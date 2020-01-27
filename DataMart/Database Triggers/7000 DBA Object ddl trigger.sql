CREATE TRIGGER [7000 DBA Object ddl trigger]
ON DATABASE 
FOR 
	ALTER_VIEW , DROP_VIEW, CREATE_VIEW, 
	ALTER_TABLE, DROP_TABLE, CREATE_TABLE,
	ALTER_TRIGGER, DROP_TRIGGER, CREATE_TRIGGER, 
	ALTER_INDEX, DROP_INDEX, CREATE_INDEX,
	CREATE_PARTITION_FUNCTION, ALTER_PARTITION_FUNCTION, DROP_PARTITION_FUNCTION,
	CREATE_PARTITION_SCHEME, ALTER_PARTITION_SCHEME,DROP_PARTITION_SCHEME,
	CREATE_PROCEDURE, ALTER_PROCEDURE, DROP_PROCEDURE,
	RENAME,
	GRANT_DATABASE, DENY_DATABASE, REVOKE_DATABASE,
	CREATE_ROLE, ALTER_ROLE, DROP_ROLE,
	CREATE_SCHEMA, ALTER_SCHEMA, DROP_SCHEMA,
	ADD_ROLE_MEMBER, DROP_ROLE_MEMBER,
	CREATE_FUNCTION, ALTER_FUNCTION, DROP_FUNCTION,
	CREATE_APPLICATION_ROLE, ALTER_APPLICATION_ROLE, DROP_APPLICATION_ROLE,
	CREATE_TYPE, DROP_TYPE,
	CREATE_USER, ALTER_USER, DROP_USER
AS 
BEGIN

	SET ANSI_NULLS ON
	SET QUOTED_IDENTIFIER ON
	SET ARITHABORT ON
	SET ANSI_PADDING ON
	SET ANSI_WARNINGS ON
	SET CONCAT_NULL_YIELDS_NULL ON

	DECLARE @Before nvarchar(max)
	DECLARE @ExecString nvarchar(4000)
	DECLARE @ParmDefinition nvarchar(500)

	DECLARE @EventType nvarchar(128)
	DECLARE @PostTime datetime
	DECLARE @SPID nvarchar(5)
	DECLARE @LoginName nvarchar(128)
	DECLARE @UserName nvarchar(128)
	DECLARE @DatabaseName nvarchar(128)
	DECLARE @SchemaName nvarchar(128)
	DECLARE @ObjectName nvarchar(128)
	DECLARE @ObjectType nvarchar(128)
	DECLARE @TSQLCommand nvarchar(max)
	
	SELECT @DatabaseName = EVENTDATA().value('(/EVENT_INSTANCE/DatabaseName)[1]','nvarchar(128)')	
	--SELECT @ObjectName = EVENTDATA().value('(/EVENT_INSTANCE/ObjectName)[1]','nvarchar(128)')	
	--SELECT @SchemaName = EVENTDATA().value('(/EVENT_INSTANCE/SchemaName)[1]','nvarchar(128)')	
	--SELECT @ObjectType = EVENTDATA().value('(/EVENT_INSTANCE/ObjectType)[1]','nvarchar(128)')	
	SELECT @LoginName = EVENTDATA().value('(/EVENT_INSTANCE/LoginName)[1]','nvarchar(128)')
	--SELECT @UserName = EVENTDATA().value('(/EVENT_INSTANCE/UserName)[1]','nvarchar(128)')
	--SELECT @SPID = EVENTDATA().value('(/EVENT_INSTANCE/SPID)[1]','nvarchar(5)')
	SELECT @TSQLCommand = EVENTDATA().value('(/EVENT_INSTANCE/TSQLCommand)[1]','nvarchar(max)')
	--SELECT @EventType = EVENTDATA().value('(/EVENT_INSTANCE/EventType)[1]','nvarchar(128)')	
	--SELECT @PostTime = EVENTDATA().value('(/EVENT_INSTANCE/PostTime)[1]','nvarchar(128)')

	IF @DatabaseName IN ('DataMart', 'BI_LoadDb', 'BI_ToolBox', 'BI_TempDb') AND @@SERVERNAME = 'PSRVWDB1663\PSQLPBI0002'
	BEGIN
		IF @LoginName NOT IN ('ACCDOM01\M88136_ADM', 'ACCDOM01\MORKI')
		BEGIN
			BEGIN TRY
				IF NOT EXISTS(SELECT TOP 1 1 FROM [BI_ToolBox].[dbo].[7000 DBA Object Dll Trigger Grants] D WHERE D.[LoginName] = @LoginName AND D.[Logtime] > DATEADD(HOUR, -1, GETDATE()))
				BEGIN
					
					DECLARE @Msg nvarchar(MAX)
					SELECT @Msg = 'You are not Morten Kirkebæk, and therefore you need to register your name: '+@LoginName+' and a short description ;-)
This will allow you to do you do changes on the database for one hour.

Use this script to register your need to update the database and get access to update/change the database:
INSERT INTO [BI_ToolBox].[dbo].[7000 DBA Object Dll Trigger Grants register]([LoginName],[Description])
VALUES('''+@LoginName+''', ''<your description>'')

'
					PRINT @Msg
					ROLLBACK
				END
				ELSE
				BEGIN
					INSERT INTO [BI_ToolBox].[dbo].[7005 Objects Changes logger]([LoginName], [TSQL])
					VALUES(@LoginName, @TSQLCommand)
				END				
			END TRY
			BEGIN CATCH
				PRINT 'Sorry you dont have access to do this. Connect m88136@tdc.dk or another database administrator if you need help :-).'
				ROLLBACK
			END CATCH
		END
	END
END