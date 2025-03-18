CREATE PROCEDURE [dbo].[UpdateUom]
	  @UomId					INT
	, @Name						NVARCHAR(50)
	, @AllowDecimalQuantity		BIT		= NULL
	, @ReturnCode				INT		= NULL	OUT
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

		IF NULLIF(@Name,'') IS NULL
		BEGIN
			SET @ReturnCode = -1
			RETURN @ReturnCode
		END

		IF NOT EXISTS
		(
			SELECT	1
			FROM	[dbo].[Uom]
			WHERE	[UomId] = @UomId
		)
		BEGIN
			SET @ReturnCode = -2
			RETURN @ReturnCode
		END

		IF @EntryTranCount = 0 
			BEGIN TRANSACTION
			
		UPDATE	[dbo].[Uom]
		SET		  [Name] = @Name
				, [AllowDecimalQuantity] = ISNULL(@AllowDecimalQuantity,[AllowDecimalQuantity])
		WHERE	[UomId] = @UomId

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
