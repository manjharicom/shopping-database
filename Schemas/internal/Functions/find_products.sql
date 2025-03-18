CREATE FUNCTION [internal].[find_products]
(
	  @search_text		NVARCHAR(4000)
	, @category_id		INT
	, @area_Id			INT	
)
RETURNS TABLE AS RETURN
(
	SELECT	  p.[ProductId]
			, p.[CategoryId]
			, p.[AreaId]
			, p.[Name]
			, p.[IsShipped]
			, p.[UomId]
			, p.[PriceUomId]
	FROM	[internal].[udf_find_products_matching_keywords]
			(
				[internal].[udf_full_text_search_string](@search_text)
				, @category_id
				, @area_Id
			) p
)