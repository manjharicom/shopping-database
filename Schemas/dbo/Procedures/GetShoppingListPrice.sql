CREATE PROCEDURE [dbo].[GetShoppingListPrice]
	  @ShoppingListPriceId		INT	
	, @ReturnCode				INT									= NULL	OUT
AS
BEGIN
	--! Set output parameters.
	SET @ReturnCode = 0

	BEGIN TRY
		--! Reduce unnecessary network traffic and force rollback and aborting upon any error.
		SET NOCOUNT ON
		SET XACT_ABORT ON

		SELECT	  [ShoppingListPriceId]
				, [ShoppingListId]
				, [ShoppingDate]
		FROM	[dbo].[ShoppingListPrice]
		WHERE	[ShoppingListPriceId] = @ShoppingListPriceId

		--! Return success.
		RETURN 0
	END TRY

	BEGIN CATCH
		IF @@trancount > 0 ROLLBACK TRANSACTION
		EXEC [internal].[CatchHandler] @proc_id = @@PROCID
		RETURN 55555
	END CATCH
END
