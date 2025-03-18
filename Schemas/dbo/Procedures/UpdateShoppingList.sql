CREATE PROCEDURE [dbo].[UpdateShoppingList]
	  @ShoppingListId		INT
	, @CheckListId			NVARCHAR(50)	= NULL
	, @BoardId				NVARCHAR(50)	= NULL
	, @Name					NVARCHAR(50)	= NULL
	, @ReturnCode			INT				= NULL	OUT
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

		IF @CheckListId IS NULL AND @BoardId IS NULL AND @Name IS NULL
		BEGIN
			RETURN @ReturnCode
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

		IF @EntryTranCount = 0 
			BEGIN TRANSACTION

		UPDATE	[dbo].[ShoppingList]
		SET		  [DateModified] = @now
				, [CheckListId] = ISNULL(@CheckListId,[CheckListId])
				, [BoardId] = ISNULL(@BoardId,[CheckListId])
				, [Name] = ISNULL(@Name,[Name])
		WHERE	[ShoppingListId] = @ShoppingListId

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
