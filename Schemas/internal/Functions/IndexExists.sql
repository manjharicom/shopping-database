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
