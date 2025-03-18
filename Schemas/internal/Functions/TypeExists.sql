CREATE FUNCTION [internal].[TypeExists]
(
	  @ObjectName	SYSNAME
)
RETURNS BIT
AS
BEGIN
	RETURN
		(
			CASE 
				WHEN EXISTS
						(
							SELECT	1 
							FROM	[internal].[SplitObjectName](@ObjectName) n
									INNER JOIN [sys].[schemas] s
										ON	s.[name] = n.[SchemaName]
									INNER JOIN [sys].[types] t
										ON	t.[name] = n.[ObjectName] 
										AND	t.[schema_id] = s.[schema_id]
							WHERE	[is_table_type] = 1
							 AND	[is_user_defined] = 1
						)
					THEN 1
				ELSE 0
			END	
		)
END
