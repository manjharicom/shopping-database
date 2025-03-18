CREATE FUNCTION [internal].[UdfGetStaticDataStatement]
(
	  @SchemaName	SYSNAME
	, @TableName	SYSNAME
)
RETURNS TABLE AS RETURN
(
	SELECT
			  sds.[Statement]
	FROM	[Admin].[StaticData] sd
			INNER JOIN [Admin].[StaticDataStatements] sds
				ON	sds.[StaticDataId] = sd.[StaticDataId]
	WHERE	sd.[SchemaName] = ISNULL(@SchemaName,sd.[SchemaName])
	 AND	sd.[TableName] = ISNULL(@TableName,sd.[TableName])
)
