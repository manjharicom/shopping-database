CREATE FUNCTION [internal].[find_menus]
(
	@search_text		NVARCHAR(4000)
)
RETURNS TABLE AS RETURN
(
	SELECT	  p.[MenuId]
			, p.[Name]
			, p.[CookingInstructions]
	FROM	[internal].[udf_find_menus_matching_keywords]
			(
				[internal].[udf_full_text_search_string](@search_text)
			) p
)