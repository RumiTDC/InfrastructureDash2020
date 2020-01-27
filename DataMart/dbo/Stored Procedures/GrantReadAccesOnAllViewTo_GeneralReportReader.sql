CREATE PROCEDURE [dbo].[GrantReadAccesOnAllViewTo_GeneralReportReader]
AS
BEGIN

	/*	How to call

	EXECUTE [DataMart].[dbo].[GrantReadAccesOnAllViewTo_GeneralReportReader]
	
	*/

	--DECLARE @ExecString varchar(200)

	--DECLARE GrantCur CURSOR
	--FOR
	--SELECT
	--	'GRANT SELECT ON ' + QUOTENAME(S.[name]) + '.' + QUOTENAME(O.[name]) + ' TO [GeneralReportReader]'
	--FROM sys.objects O
	--	JOIN sys.schemas S
	--		ON S.[schema_id] = O.[schema_id]
	--WHERE
	--	O.[type] = 'V'

	--OPEN GrantCur

	--FETCH NEXT FROM GrantCur INTO @ExecString

	--WHILE @@FETCH_STATUS = 0
	--BEGIN

	--	EXECUTE(@ExecString)

	--	FETCH NEXT FROM GrantCur INTO @ExecString
	--END

	--CLOSE GrantCur
	--DEALLOCATE GrantCur

	SELECT 'Pt. gives der kun adgang til nye views specifikt.' AS [State]

	RETURN(1)
END