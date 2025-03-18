CREATE FUNCTION [internal].[ColumnExists]
(
	  @ObjectName	SYSNAME
	, @ColumnName	SYSNAME
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
							FROM	[sys].[syscolumns]
							WHERE	[name] = @ColumnName 
							 AND	[id] = OBJECT_ID(@ObjectName)
						)
					THEN 1
				ELSE 0
			END	
		)
END
