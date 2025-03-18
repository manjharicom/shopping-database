CREATE FUNCTION [internal].[ProductsJson]
(
	  @CategoryId			INT
	, @AreaId				INT
	, @IncludeProducts		BIT = 0
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
	RETURN 
	(
		SELECT	  P.[ProductId]
				, p.[Name]
				, [ShoppingListId] = [internal].[ExistsInShoppingList](p.[ProductId])
		FROM	[dbo].[Product] p
		WHERE	@IncludeProducts = 1
		AND		(
					(
						@CategoryId IS NOT NULL
						AND	p.[CategoryId] = @CategoryId
					)
				OR 
					(
						@AreaId IS NOT NULL
						AND	p.[AreaId] = @AreaId
					)
				)
		ORDER BY p.[Name]
				FOR JSON PATH
	)
END
