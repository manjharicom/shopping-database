CREATE PROCEDURE [dbo].[AddShoppingListPrice]
	  @ShoppingListId			INT
	, @ShoppingDate				DATE
	, @Prices					[dbo].[UdtShoppingListProductPrice]	READONLY
	, @ShoppingListPriceId		INT									= NULL OUT
	, @ReturnCode				INT									= NULL	OUT
AS
BEGIN
	--! Set output parameters.
	SET @ShoppingListPriceId = @ShoppingListPriceId
	SET @ReturnCode = 0

	BEGIN TRY
		--! Reduce unnecessary network traffic and force rollback and aborting upon any error.
		SET NOCOUNT ON
		SET XACT_ABORT ON

		--! Locals.
		DECLARE @EntryTranCount				INT					= @@TRANCOUNT
		DECLARE @now						DATETIME			= GETDATE()

		IF @ShoppingDate IS NULL
		BEGIN
			SET @ShoppingDate = @now
		END

		IF NOT EXISTS
		(
			SELECT	1
			FROM	[dbo].[ShoppingList]
			WHERE	[ShoppingListId] = @ShoppingListId
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

		INSERT	[dbo].[ShoppingListPrice]
		(
			  [ShoppingListId]
			, [ShoppingDate]
		)
		VALUES
		(
			  @ShoppingListId
			, @ShoppingDate
		)

		SET @ShoppingListPriceId = SCOPE_IDENTITY()

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
