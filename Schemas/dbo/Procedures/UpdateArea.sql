CREATE PROCEDURE [dbo].[UpdateArea]
	  @AreaId		INT
	, @Name			NVARCHAR(255)	= NULL
	, @ReturnCode	INT				= NULL	OUT
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

		IF @AreaId IS NULL
			AND @Name IS NULL
		BEGIN
			RETURN @ReturnCode
		END

		IF @AreaId IS NOT NULL AND NOT EXISTS
		(
			SELECT	1
			FROM	[dbo].[Area] c
			WHERE	[AreaId] = @AreaId
		)
		BEGIN
			SET @ReturnCode = -1
			RETURN @ReturnCode
		END

		IF @AreaId IS NOT NULL AND EXISTS
		(
			SELECT	1
			FROM	[dbo].[Area] c
			WHERE	[AreaId] = @AreaId
			AND		c.[IsShipped] = 1
		) 
		BEGIN
			SET @ReturnCode = -2
			RETURN @ReturnCode
		END

		IF @EntryTranCount = 0 
			BEGIN TRANSACTION

		UPDATE	[dbo].[Area]
		SET		[Name] = ISNULL(@Name, [Name])
		WHERE	[AreaId] = @AreaId

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
