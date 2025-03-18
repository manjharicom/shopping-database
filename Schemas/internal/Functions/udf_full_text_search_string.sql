/*
 * Purpose
 *		Turn space delimited search string into CONTAINSTABLE search parameter.
 * Information
 *		Splits string into space delimited tokens and then build two search clauses
 *		for the use in a CONTAINSTABLE call. First adds wildcard to each non-numeric token and 
 *		then uses near option across all tokens. Second uses inflectional FORMSOF to embellish
 *		token(s) provided - without any wildcarding.
 * Limitations
 *		Full text searching cannot find special characters therefore remove any double 
 *		quote from search string. Also any single character tokens or non-alphanumeric tokens 
 *		are removed from inflectional checking.
 * Examples
 *		Example 1: 'ice tea' becomes '("ice*" NEAR "tea*") OR (FORMSOF(INFLECTIONAL,"ice") AND FORMSOF(INFLECTIONAL,"tea"))'
 *		Example 2: 'pasta spaghetti #5' becomes '("Pasta*" NEAR "Spaghetti*" NEAR "#5*") OR (FORMSOF(INFLECTIONAL,"Pasta") AND FORMSOF(INFLECTIONAL,"Spaghetti"))'
 *		Example 3: 'tort miss 6' becomes '("tort*" NEAR "miss*" NEAR "6*") OR (FORMSOF(INFLECTIONAL,"tort") AND FORMSOF(INFLECTIONAL,"miss") AND FORMSOF(INFLECTIONAL,"6"))'
 * History
 *		Date		Person		Change
 *		-----------	-----------	------------------------------------------------
 *		02 Dec 2021	John		MP-7022 - Created.
 */

CREATE FUNCTION [internal].[udf_full_text_search_string]
(
	  @search_string					NVARCHAR(255)
)
RETURNS NVARCHAR(4000)
AS 
BEGIN
	DECLARE @near_string				NVARCHAR(MAX)
	DECLARE @inflectional_string		NVARCHAR(MAX)
	DECLARE @result_string			NVARCHAR(MAX)

	--! remove " if more than 2. Causes too many problems
	IF [internal].[udf_count_string_occurrences]('"', @search_string) > 2
		BEGIN
			SELECT @search_string = REPLACE(@search_string,'"','')
		END

	;WITH SearchTokens AS
		(
			SELECT	Token = [value]
			FROM	[internal].[udf_split_text_to_table](@search_string,N' ')
		)
	SELECT	  @near_string = 
				CASE
					WHEN [internal].[udf_count_string_occurrences]('"', @search_string) > 0
						THEN N''
					ELSE
						COALESCE(@near_string + N' , ',N'') + 
						N'"' + 
						Token + 
						N'*"'
				END
			, @inflectional_string = 
				CASE
					WHEN [internal].[udf_count_string_occurrences]('"', @search_string) > 0
						THEN N''
					ELSE
						COALESCE(@inflectional_string,N'') + 
						CASE 
							WHEN LEN(Token) = 1 AND PATINDEX(N'%[a-zA-Z]%',Token) > 0 
								THEN N'' 
							WHEN PATINDEX(N'%[^a-zA-Z0-9-]%',Token) > 0 
								THEN N'' 
							ELSE 
								CASE 
									WHEN LEN(@inflectional_string) > 1 
										THEN N' AND FORMSOF(INFLECTIONAL,"' + Token + N'")' 
									ELSE N'FORMSOF(INFLECTIONAL,"' + Token + N'")' 
								END 
					END
				END
			, @result_string = 
				CASE
					WHEN [internal].[udf_count_string_occurrences]('"', @search_string) = 2
						THEN @search_string
					ELSE N''
				END
	FROM	SearchTokens

	RETURN	
		CASE
			WHEN LEN(@result_string) > 0
				THEN @result_string
			ELSE
				N''
		END
		+
		CASE
			WHEN @near_string = N'' 
				THEN N''
			ELSE
				CASE 
					WHEN CHARINDEX(N',',@near_string) > 0 
						THEN N'NEAR' 
					ELSE N'' 
				END + N'(' + @near_string + N')'
		END
		+ 
		CASE 
			WHEN @inflectional_string = N'' 
				THEN N'' 
			ELSE N' OR (' + @inflectional_string + N')' 
		END
END
GO