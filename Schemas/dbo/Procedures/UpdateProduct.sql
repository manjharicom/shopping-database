CREATE PROCEDURE [dbo].[UpdateProduct]
	  @ProductId	INT
	, @CategoryId	INT				= NULL
	, @AreaId		INT				= NULL
	, @Name			NVARCHAR(255)	= NULL
	, @UomId		INT				= NULL
	, @PriceUomId	INT				= NULL
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
		DECLARE @now						DATETIME			= GETDATE()

		IF @CategoryId IS NULL
			AND @AreaId IS NULL
			AND @Name IS NULL
		BEGIN
			RETURN @ReturnCode
		END

		IF @CategoryId IS NOT NULL AND NOT EXISTS
		(
			SELECT	1
			FROM	[dbo].[Category] c
			WHERE	[CategoryId] = @CategoryId
		)
		BEGIN
			SET @ReturnCode = -1
			RETURN @ReturnCode
		END

		IF @AreaId IS NOT NULL AND NOT EXISTS
		(
			SELECT	1
			FROM	[dbo].[Area] c
			WHERE	[AreaId] = @AreaId
		) 
		BEGIN
			SET @ReturnCode = -2
			RETURN @ReturnCode
		END

		IF @EntryTranCount = 0 
			BEGIN TRANSACTION

		UPDATE	[dbo].[Product]
		SET		  [Name] = ISNULL(@Name, [Name])
				, [CategoryId] = ISNULL(@CategoryId, [CategoryId])
				, [AreaId] = ISNULL(@AreaId, [AreaId])
				, [UomId] = ISNULL(@UomId, [UomId])
				, [PriceUomId] = ISNULL(@PriceUomId, [PriceUomId])
		WHERE	[ProductId] = @ProductId

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
