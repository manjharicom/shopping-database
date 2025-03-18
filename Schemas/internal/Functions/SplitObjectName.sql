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
