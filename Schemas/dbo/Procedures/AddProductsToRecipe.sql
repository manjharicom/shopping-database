CREATE PROCEDURE [dbo].[AddProductsToRecipe]
	  @RecipeId			INT
	, @Products			[dbo].[UdtRecipeProduct]	READONLY
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

		IF EXISTS
		(
			SELECT	1
			FROM	@Products
		)
		BEGIN
			DELETE	[dbo].[RecipeProduct]
			WHERE	[RecipeId] = @RecipeId

			INSERT [dbo].[RecipeProduct]
			(
				  [RecipeId]
				, [ProductId]
				, [Measurement]
			)
			SELECT	  @RecipeId
					, p.[ProductId]
					, p.[Measurement]
			FROM	@Products p
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
