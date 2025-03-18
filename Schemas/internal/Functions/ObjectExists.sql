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
