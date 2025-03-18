CREATE PROCEDURE [dbo].[GetShoppingLists]
	  @ShoppingLists		[dbo].[UdtId]	READONLY
	, @ReturnCode			INT		= NULL	OUT
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
			FROM	@ShoppingLists
		)
		BEGIN
			SELECT	  [ShoppingListId]
					, [Name]
					, [CheckListId]
					, [BoardId]
					, [SuperMarketId]
			FROM	[dbo].[ShoppingList]
		END
		ELSE
		BEGIN
			SELECT	  [ShoppingListId]
					, [Name]
					, [CheckListId]
					, [BoardId]
					, [SuperMarketId]
			FROM	[dbo].[ShoppingList] c
					CROSS APPLY @ShoppingLists ca
			WHERE	ca.[Id] = c.[ShoppingListId]
			ORDER BY c.[Name]
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
