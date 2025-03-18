CREATE PROCEDURE [dbo].[GetShoppingListProducts]
	  @ShoppingListId		INT
	, @ReturnCode			INT		= NULL	OUT
AS
BEGIN
	--! Set output parameters.
	SET @ReturnCode = 0

	BEGIN TRY
		--! Reduce unnecessary network traffic and force rollback and aborting upon any error.
		SET NOCOUNT ON
		SET XACT_ABORT ON

		SELECT	  P.[ProductId]
				, P.[Name]
				, csm.[AisleLabel]
				, [Sequence] = ISNULL(csm.[Sequence], 100)
				, slp.[Quantity]
				, p.[IsShipped]
				, slp.[ShoppingListId]
				, p.[UomId]
				, [Uom] = u.[Name]
				, p.[PriceUomId]
				, [PriceUom] = u2.[Name]
				, u2.[AllowDecimalQuantity]
				, slp.[Purchased]
		FROM	[dbo].[ShoppingListProduct] slp
				INNER JOIN [dbo].[ShoppingList] sl
					ON slp.[ShoppingListId] = sl.[ShoppingListId]
				INNER JOIN [dbo].[Product] p
					ON slp.[ProductId] = p.[ProductId]
				LEFT OUTER JOIN [dbo].[CategorySuperMarket] csm
					ON csm.[CategoryId] = p.[CategoryId]
					AND csm.[SuperMarketId] = sl.[SuperMarketId]
				LEFT OUTER JOIN [dbo].[Uom] u
					ON p.[UomId] = u.[UomId]
				LEFT OUTER JOIN [dbo].[Uom] u2
					ON p.[PriceUomId] = u2.[UomId]
		WHERE	slp.[ShoppingListId] = @ShoppingListId
		ORDER BY [Sequence]

		--! Return success.
		RETURN 0
	END TRY

	BEGIN CATCH
		IF @@trancount > 0 ROLLBACK TRANSACTION
		EXEC [internal].[CatchHandler] @proc_id = @@PROCID
		RETURN 55555
	END CATCH
END
