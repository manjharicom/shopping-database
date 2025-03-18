CREATE PROCEDURE [dbo].[GetShoppingListPrices]
	@IncludePrices		BIT = 0,
	@Ids				[dbo].[UdtId]	READONLY,
	@ReturnCode			INT		= NULL	OUT
AS
BEGIN
	--! Set output parameters.
	SET @ReturnCode = 0

	BEGIN TRY
		--! Reduce unnecessary network traffic and force rollback and aborting upon any error.
		SET NOCOUNT ON
		SET XACT_ABORT ON

		IF NOT EXISTS
		(
			SELECT	1
			FROM	@Ids
		)
		BEGIN
			SELECT	  [ShoppingListPriceId]
					, [ShoppingListId]
					, [ShoppingDate]
					, [PricesJson] = [internal].[ShoppingListProductPriceJson](c.[ShoppingListPriceId], @IncludePrices)
			FROM	[dbo].[ShoppingListPrice] c
			ORDER BY c.[ShoppingDate]
		END
		ELSE
		BEGIN
			SELECT	  [ShoppingListPriceId]
					, [ShoppingListId]
					, [ShoppingDate]
					, [PricesJson] = [internal].[ShoppingListProductPriceJson](c.[ShoppingListPriceId], @IncludePrices)
			FROM	[dbo].[ShoppingListPrice] c
					CROSS APPLY @Ids ca
			WHERE	ca.[Id] = c.[ShoppingListPriceId]
			ORDER BY c.[ShoppingDate]
		END

		--! Return success.
		RETURN 0
	END TRY

	BEGIN CATCH
		IF @@trancount > 0 ROLLBACK TRANSACTION
		EXEC [internal].[CatchHandler] @proc_id = @@PROCID
		RETURN 55555
	END CATCH
END
