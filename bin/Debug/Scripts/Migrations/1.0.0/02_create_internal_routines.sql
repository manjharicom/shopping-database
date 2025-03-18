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
GO

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
GO

CREATE FUNCTION [internal].[IndexExists]
(
	  @ObjectName	SYSNAME
	, @IndexName	SYSNAME
)
RETURNS BIT
AS
BEGIN
	RETURN
		(
			CASE 
				WHEN INDEXPROPERTY(OBJECT_ID(@ObjectName),@IndexName,'IndexID') IS NOT NULL
					THEN 1
				ELSE 0
			END	
		)
END
GO

CREATE FUNCTION [internal].[SplitObjectName]
(
	  @ObjectName	SYSNAME
)
RETURNS TABLE AS RETURN
(
	SELECT
				  [SchemaName] = 
					CASE
						WHEN CHARINDEX('[', sch.[SchemaName]) > 0
							THEN SUBSTRING(sch.[SchemaName],2,LEN(sch.[SchemaName]) - 2)
						ELSE sch.[SchemaName]
					END
				, [ObjectName] =
					CASE
						WHEN CHARINDEX('[', obj.[ObjectName]) > 0
							THEN SUBSTRING(obj.[ObjectName],2,LEN(obj.[ObjectName]) - 2)
						ELSE obj.[ObjectName]
					END	
		FROM	(
					SELECT [ObjectName] = REPLACE(LTRIM(RTRIM(@ObjectName)),'''','')
				) clean
				CROSS APPLY
				(
					SELECT	[SchemaName] =
								CASE
									WHEN CHARINDEX('.', clean.[ObjectName]) > 0
										THEN SUBSTRING(clean.[ObjectName],1,CHARINDEX('.', clean.[ObjectName]) - 1)
									ELSE NULL
								END
				) sch
				CROSS APPLY
				(
					SELECT	[ObjectName] =
								CASE
									WHEN CHARINDEX('.', clean.[ObjectName]) > 0
										THEN SUBSTRING(clean.[ObjectName],CHARINDEX('.', clean.[ObjectName]) + 1,LEN(clean.[ObjectName]))
									ELSE clean.[ObjectName]
								END
				) obj
)
GO

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
GO

CREATE FUNCTION [internal].[GetModifiedCode]
(
)
RETURNS TABLE AS RETURN
(
	SELECT	
				  s.[name] AS [SchemaName]
				, o.[name] AS [ObjectName]
				, o.[type]
				, o.[create_date]
				, o.[modify_date]
		FROM	[sys].[objects] o
				INNER JOIN [sys].[schemas] s
					ON	s.[schema_id] = o.[schema_id]
		WHERE	o.[type] in ( 'FN' , 'FS', 'FT', 'IF' , 'P', 'PC', 'TA', 'TF', 'TR', 'X' )
)
GO

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
GO

CREATE FUNCTION [internal].[ObjectExists]
(
	  @ObjectName	SYSNAME
	, @ObjectType	SYSNAME
)
RETURNS BIT
AS
BEGIN
	RETURN
		(
			CASE 
				WHEN @ObjectType = 'TR' AND (SELECT @@VERSION) LIKE '%SQL Server 2008%'
					THEN
						CASE 
							WHEN EXISTS
									(
										SELECT	1 
										FROM	[internal].[SplitObjectName](@ObjectName) n
												INNER JOIN [sys].[triggers] t
													ON	t.[name] = n.[ObjectName]
									)
								THEN 1
							ELSE 0
						END	
				WHEN OBJECT_ID(@ObjectName,@ObjectType) IS NOT NULL
					THEN 1
				ELSE 0
			END	
		)
END
GO

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
GO
