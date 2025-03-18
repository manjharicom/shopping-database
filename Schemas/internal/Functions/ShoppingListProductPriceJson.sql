CREATE FUNCTION [internal].[ShoppingListProductPriceJson]
(
	  @ShoppingListPriceId		INT	
	, @IncludePrices			BIT = 0
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
	RETURN 
	(
		SELECT	  P.[ShoppingListPriceId]
				, P.[ProductId]
				, p.[Comment]
				, p.[Quantity]
				, p.[Price]
				, p.[Total]
		FROM	[dbo].[ShoppingListProductPrice] p
		WHERE	[ShoppingListPriceId] = @ShoppingListPriceId
		AND		@IncludePrices = 1
		ORDER BY p.[ProductId]
				FOR JSON PATH
	)
END
