CREATE FUNCTION [internal].[UdfGetObjectName]
(
	  @SchemaName		SYSNAME
	, @TableName		SYSNAME
)
RETURNS SYSNAME
AS
BEGIN
	RETURN
		(
			SELECT ISNULL('[' + @SchemaName + '].[','[') + @TableName + ']'
		)
END
