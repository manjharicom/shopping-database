CREATE PROCEDURE [dbo].[AddRecipeToMenu]
	  @MenuId			INT
	, @RecipeId			INT
	, @ReturnCode		INT							= NULL	OUT
AS
BEGIN
	--! Set output parameters.
	SET @ReturnCode = 0

	BEGIN TRY
		--! Reduce unnecessary network traffic and force rollback and aborting upon any error.
		SET NOCOUNT ON
		SET XACT_ABORT ON

		--! Locals.
		DECLARE @EntryTranCount		INT			= @@TRANCOUNT

		IF @EntryTranCount = 0 
			BEGIN TRANSACTION

		IF NOT EXISTS
		(
			SELECT	1
			FROM	[dbo].[MenuRecipe]
			WHERE	[MenuId] = @MenuId
			AND		[RecipeId] = @RecipeId
		)
		BEGIN
			INSERT [dbo].[MenuRecipe]
			(
				  [MenuId]
				, [RecipeId]
			)
			SELECT	  @MenuId
					, @RecipeId
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
