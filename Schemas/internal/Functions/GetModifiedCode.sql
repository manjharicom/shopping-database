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
