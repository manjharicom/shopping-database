CREATE PROCEDURE [dbo].[AddProductsToShoppingList]
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

		IF @EntryTranCount = 0 
			BEGIN TRANSACTION

		INSERT [dbo].[ShoppingListProduct]
			(
				  [ShoppingListId]
				, [ProductId]
				, [DateCreated]
				, [DateModified]
			)
			SELECT
					  @ShoppingListId
					, p.Id
					, @now
					, @now
			FROM	@Products p
			WHERE	NOT EXISTS
					(
						SELECT	1
						FROM	[dbo].[ShoppingListProduct] slp
						WHERE	slp.[ProductId] = p.[Id]
						AND		slp.[ShoppingListId] = @ShoppingListId
					)

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
