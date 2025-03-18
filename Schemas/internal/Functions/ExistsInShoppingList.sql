CREATE FUNCTION [internal].[ExistsInShoppingList]
(
	@ProductId	INT
)
RETURNS INT
AS
BEGIN
	RETURN
		(
			SELECT	TOP 1 slp.[ShoppingListId]
			FROM	[dbo].[ShoppingListProduct] slp
			WHERE	slp.[ProductId] = @ProductId
		)
END
