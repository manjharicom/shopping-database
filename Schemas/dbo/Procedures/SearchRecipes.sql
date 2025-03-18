CREATE PROCEDURE [dbo].[SearchRecipes]
	  @SearchText		NVARCHAR(4000)		= NULL
	, @ReturnCode		INT					= NULL	OUT
AS
BEGIN
	--! Set output parameters.
	SET @ReturnCode = 0

	BEGIN TRY
		--! Reduce unnecessary network traffic and force rollback and aborting upon any error.
		SET NOCOUNT ON
		SET XACT_ABORT ON

		SELECT	  p.[RecipeId]
				, p.[Name]
				, p.[CookingInstructions]
		FROM	[internal].[find_recipes](@SearchText) p
		--! Return success.
		RETURN 0
	END TRY

	BEGIN CATCH
		IF @@trancount > 0 ROLLBACK TRANSACTION
		EXEC [internal].[CatchHandler] @proc_id = @@PROCID
		RETURN 55555
	END CATCH
END
