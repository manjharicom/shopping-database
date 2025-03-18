
/*
 * Purpose
 *		Split string into separate tokens based on delimiter provided. 
 * Information
 *		Returns one row per token along with token location within string 
 *		starting at 1 for first.
 *		Routine is an inline table valued function and uses XML, rather than 
 *		recursive CTE or looping, for speed.
 *		Replaces the XML escape character "&" with explicit value "&amp;" to prevent
 *		XML parsing errors.
 * History
 *		Date		Person		Change
 *		-----------	-----------	------------------------------------------------
 *		14 Aug 2019	Ian			MP-1750 - created.
 *		02 Dec 2021	John		MP-7022 - cater for < and >.
 */

CREATE FUNCTION [internal].[udf_split_text_to_table] 
(
	  @text_string							NVARCHAR(MAX)
	, @delimiter							NCHAR(1)
)
RETURNS TABLE AS RETURN
(
	WITH XMLString AS 
		(
			SELECT CAST('<Token>' + REPLACE(REPLACE(REPLACE(REPLACE(NULLIF(@text_string,N''), N'&', N'&amp;'), N'<', N'&lt;'), N'>', N'&gt;') , @delimiter, '</Token><Token>') + '</Token>' AS XML) AS 'XMLString'
		)
	SELECT
			  [value] = c.value('.', 'NVARCHAR(255)')
			, [position] = ROW_NUMBER() OVER (ORDER BY c.value('count(.)', 'INT'))
	FROM	XMLString
			CROSS APPLY	XMLString.nodes('/Token') AS t(c)
)