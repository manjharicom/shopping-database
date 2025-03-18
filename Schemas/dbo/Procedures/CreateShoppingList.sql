CREATE PROCEDURE [dbo].[CreateShoppingList]
	  @SuperMarketId		INT
	, @CheckListId			NVARCHAR(50)
	, @BoardId				NVARCHAR(50)
	, @Name					NVARCHAR(50)
	, @ShoppingListId		INT		= NULL	OUT
	, @ReturnCode			INT		= NULL	OUT
AS
BEGIN
	--! Set output parameters.
	SET @ShoppingListId = @ShoppingListId
	SET @ReturnCode = 0

	BEGIN TRY
		--! Reduce unnecessary network traffic and force rollback and aborting upon any error.
		SET NOCOUNT ON
		SET XACT_ABORT ON

		--! Locals.
		DECLARE @EntryTranCount				INT					= @@TRANCOUNT
		DECLARE @now						DATETIME			= GETDATE()

		IF NULLIF(@Name,'') IS NULL
		BEGIN
			SET @ReturnCode = -1
			RETURN @ReturnCode
		END

		IF EXISTS
		(
			SELECT	1
			FROM	[dbo].[ShoppingList]
			WHERE	[SuperMarketId] = @SuperMarketId
		)
		BEGIN
			SET @ReturnCode = -2
			RETURN @ReturnCode
		END

		IF @EntryTranCount = 0 
			BEGIN TRANSACTION

		INSERT [dbo].[ShoppingList]
			(
				  [SuperMarketId]
				, [DateCreated]
				, [DateModified]
				, [CheckListId]
				, [Name]
				, [BoardId]
			)
			VALUES
			(
				  @SuperMarketId
				, @now
				, @now
				, @CheckListId
				, @Name
				, @BoardId
			)

		SET @ShoppingListId = SCOPE_IDENTITY()

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
