CREATE FUNCTION [internal].[ExtendedPropertyExists]
(
	  @ObjectName		SYSNAME
	, @PropertyName		SYSNAME
	, @ColumnName		SYSNAME
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
							FROM	[sys].[extended_properties] ep
							WHERE	ep.[major_id] = OBJECT_ID(@ObjectName)
							 AND	ep.[name] = @PropertyName
							 AND	( ( @ColumnName IS NULL
									AND	ep.[minor_id] = 0
									  )
								OR	  ep.[minor_id] = 
										(
											SELECT	sc.[colid]
											FROM	[sys].[syscolumns] sc
											WHERE	sc.[id] = ep.[major_id]
											 AND	sc.[name] = @ColumnName
										)
									)
						)
					THEN 1
				ELSE 0
			END	
		)
END
