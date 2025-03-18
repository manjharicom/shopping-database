CREATE PROCEDURE [dbo].[AddProductToRecipe]
	  @RecipeId			INT
	, @ProductId		INT
	, @Measurement		NVARCHAR(4000)
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
			FROM	[dbo].[RecipeProduct]
			WHERE	[RecipeId] = @RecipeId
			AND		[ProductId] = @ProductId
		)
		BEGIN
			INSERT [dbo].[RecipeProduct]
			(
				  [RecipeId]
				, [ProductId]
				, [Measurement]
			)
			SELECT	  @RecipeId
					, @ProductId
					, @Measurement
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
