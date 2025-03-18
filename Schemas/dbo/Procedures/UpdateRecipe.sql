CREATE PROCEDURE [dbo].[UpdateRecipe]
	  @RecipeId				INT
	, @Name					NVARCHAR(255)
	, @CookingInstructions	NVARCHAR(4000)
	, @ReturnCode			INT							= NULL	OUT
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
		DECLARE @now				DATETIME	= GETDATE()

		IF NOT EXISTS
		(
			SELECT	1
			FROM	[dbo].[Recipe]
			WHERE	[RecipeId] = @RecipeId
		)
		BEGIN
			SET @ReturnCode = -1
			RETURN @ReturnCode
		END

		IF @EntryTranCount = 0 
			BEGIN TRANSACTION
			
		UPDATE	[dbo].[Recipe]
		SET		  [Name] = @Name
				, [CookingInstructions] = @CookingInstructions
				, [DateModified] = @now
		WHERE	[RecipeId] = @RecipeId

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
