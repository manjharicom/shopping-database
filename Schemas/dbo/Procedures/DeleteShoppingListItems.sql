CREATE PROCEDURE [dbo].[DeleteShoppingListItems]
	  @ShoppingListId		INT
	, @Products				[dbo].[UdtId]	READONLY
	, @ReturnCode			INT		= NULL	OUT
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
			FROM	[dbo].[ShoppingListProduct]
			WHERE	[ShoppingListId] = @ShoppingListId
		)
		BEGIN
			SET @ReturnCode = -1
			RETURN @ReturnCode
		END

		IF @EntryTranCount = 0 
			BEGIN TRANSACTION

		IF EXISTS
		(
			SELECT	1
			FROM	@Products slp
		)
		BEGIN
			DELETE	slp
			FROM	[dbo].[ShoppingListProduct] slp
					CROSS APPLY @Products p
			WHERE	[ShoppingListId] = @ShoppingListId
			AND		slp.[ProductId] = p.[Id]
		END
		ELSE
		BEGIN
			DELETE	slp
			FROM	[dbo].[ShoppingListProduct] slp
			WHERE	[ShoppingListId] = @ShoppingListId
		END

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
