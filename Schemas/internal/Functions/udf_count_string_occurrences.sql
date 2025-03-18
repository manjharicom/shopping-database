
/*
 * Purpose
 *		Count the number of occurrence of a character in a string
 * Information
 * History
 *		Date		Person		Change
 *		-----------	-----------	------------------------------------------------
 *		02 Dec 2021	John		MP-7022 - Created.
 */

CREATE FUNCTION [internal].[udf_count_string_occurrences]
(
	@search_char		CHAR(1),
	@search_string		NVARCHAR(4000)
)
RETURNS INT
AS
BEGIN
	RETURN
		(
			SELECT	LEN(ISNULL(@search_string,'')) - LEN(REPLACE(ISNULL(@search_string,''),ISNULL(@search_char,''),''))
		)
END
