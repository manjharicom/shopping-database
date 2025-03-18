CREATE FUNCTION [internal].[FormatErrorMessage]
(
	  @errmsg								NVARCHAR(2048)
	, @severity								INT	
	, @state								INT
	, @errno								INT
	, @errproc								SYSNAME
	, @lineno								INT
	, @proc									SYSNAME
)
RETURNS NVARCHAR(2048)
AS
BEGIN
	RETURN
		(
			CASE 
				WHEN @errmsg LIKE CONVERT(NVARCHAR(2048),'***%')                                     
					THEN '*** ' + COALESCE(QUOTENAME(@proc), '<dynamic SQL>') + ', Line ' + LTRIM(STR(@lineno)) + '. Errno ' + LTRIM(STR(@errno)) + ': ' + CHAR(10) + @errmsg
				ELSE '*** ' + COALESCE(QUOTENAME(@errproc), QUOTENAME(@proc), '<dynamic SQL>') + ', Line ' + LTRIM(STR(@lineno)) + '. Errno ' + LTRIM(STR(@errno)) + ': ' + @errmsg
			END
		)
END