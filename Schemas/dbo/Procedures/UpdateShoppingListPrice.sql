CREATE PROCEDURE [dbo].[UpdateShoppingListPrice]
	  @ShoppingListPriceId		INT	
	, @Prices					[dbo].[UdtShoppingListProductPrice]	READONLY
	, @ReturnCode				INT									= NULL	OUT
AS
BEGIN
	--! Set output parameters.
	SET @ReturnCode = 0

	BEGIN TRY
		--! Reduce unnecessary network traffic and force rollback and aborting upon any error.
		SET NOCOUNT ON
		SET XACT_ABORT ON

		--! Locals.
		DECLARE @EntryTranCount				INT					= @@TRANCOUNT
		DECLARE @now						DATETIME			= GETDATE()

		IF NOT EXISTS
		(
			SELECT	1
			FROM	[dbo].[ShoppingListPrice]
			WHERE	[ShoppingListPriceId] = @ShoppingListPriceId
		)
		BEGIN
			SET @ReturnCode = -1
			RETURN @ReturnCode
		END

		IF NOT EXISTS
		(
			SELECT	1
			FROM	@Prices
		)
		BEGIN
			SET @ReturnCode = -2
			RETURN @ReturnCode
		END


		IF @EntryTranCount = 0 
			BEGIN TRANSACTION

		INSERT [dbo].[ShoppingListProductPrice]
		(
			  [ShoppingListPriceId]
			, [ProductId]
			, [Comment]
			, [Quantity]
			, [Price]
			, [Total]
		)
		SELECT	  @ShoppingListPriceId
				, [ProductId]
				, [Comment]
				, [Quantity]
				, [Price]
				, [Total]
		FROM	@Prices p
		WHERE	NOT EXISTS
				(
					SELECT	1
					FROM	[dbo].[ShoppingListProductPrice] slpp
					WHERE	slpp.[ShoppingListPriceId] = @ShoppingListPriceId
					AND		slpp.[ProductId] = p.[ProductId]
				)

		UPDATE	slpp
		SET		  slpp.[Comment] = p.Comment
				, slpp.[Quantity] = p.[Quantity]
				, slpp.[Price] = p.[Price]
				, slpp.[Total] = p.[Total]
		FROM	[dbo].[ShoppingListProductPrice] slpp
				CROSS APPLY @Prices p
		WHERE	slpp.[ShoppingListPriceId] = @ShoppingListPriceId
		AND		slpp.[ProductId] = p.[ProductId]

		INSERT [dbo].[ShoppingListProductPrice]
		(
			  [ShoppingListPriceId]
			, [ProductId]
			, [Comment]
			, [Quantity]
			, [Price]
		)
		SELECT	@ShoppingListPriceId
				, [ProductId]
				, [Comment]
				, [Quantity]
				, [Price]
		FROM	@Prices p

		--! If we started the transaction then commit otherwise leave to caller.			
		IF @EntryTranCount = 0 
			COMMIT
	
		--! Return success.
		RETURN 0
	END TRY

	BEGIN CATCH
		IF @@trancount > 0 ROLLBACK TRANSACTION
		EXEC [internal].[CatchHandler] @proc_id = @@PROCID
		RETURN 55555
	END CATCH
END
