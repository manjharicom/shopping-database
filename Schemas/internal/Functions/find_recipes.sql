CREATE FUNCTION [internal].[find_recipes]
(
	@search_text		NVARCHAR(4000)
)
RETURNS TABLE AS RETURN
(
	SELECT	  p.[RecipeId]
			, p.[Name]
			, p.[CookingInstructions]
	FROM	[internal].[udf_find_recipes_matching_keywords]
			(
				[internal].[udf_full_text_search_string](@search_text)
			) p
)