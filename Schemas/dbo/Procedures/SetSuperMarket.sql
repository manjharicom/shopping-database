CREATE PROCEDURE [dbo].[SetSuperMarket]
	  @SuperMarketId	INT
	, @ReturnCode		INT		= NULL	OUT
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
		DECLARE @ShoppingListId		INT

		IF @EntryTranCount = 0 
			BEGIN TRANSACTION

		IF NOT EXISTS
		(
			SELECT	1
			FROM	[dbo].[ShoppingList]
		)
		BEGIN
			EXEC [dbo].[CreateShoppingList] 
				  @SuperMarketId = @SuperMarketId
				, @ShoppingListId = @ShoppingListId OUT
		END
		ELSE
		BEGIN
			UPDATE	[dbo].[ShoppingList]
			SET		[SuperMarketId] = @SuperMarketId

			SELECT	@ShoppingListId = [ShoppingListId]
			FROM	[dbo].[ShoppingList]
			WHERE	[SuperMarketId] = @SuperMarketId
		END
		
		UPDATE	[dbo].[ShoppingListProduct]
		SET		[ShoppingListId] = @ShoppingListId

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
