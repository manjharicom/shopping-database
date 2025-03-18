CREATE PROCEDURE [dbo].[UpdateMenu]
	  @MenuId				INT
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
			FROM	[dbo].[Menu]
			WHERE	[MenuId] = @MenuId
		)
		BEGIN
			SET @ReturnCode = -1
			RETURN @ReturnCode
		END

		IF @EntryTranCount = 0 
			BEGIN TRANSACTION
			
		UPDATE	[dbo].[Menu]
		SET		  [Name] = @Name
				, [CookingInstructions] = @CookingInstructions
				, [DateModified] = @now
		WHERE	[MenuId] = @MenuId

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
