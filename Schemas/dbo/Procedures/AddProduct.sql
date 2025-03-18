CREATE PROCEDURE [dbo].[AddProduct]
	  @CategoryId	INT
	, @AreaId		INT
	, @Name			NVARCHAR(255)
	, @UomId		INT
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

		IF @CategoryId IS NULL OR @AreaId IS NULL OR NULLIF(@Name,'') IS NULL OR @UomId IS NULL
		BEGIN
			SET @ReturnCode = -1
			RETURN @ReturnCode
		END

		IF NOT EXISTS
		(
			SELECT	1
			FROM	[dbo].[Category] c
			WHERE	[CategoryId] = @CategoryId
		) OR NOT EXISTS
		(
			SELECT	1
			FROM	[dbo].[Area] c
			WHERE	[AreaId] = @AreaId
		)
		BEGIN
			SET @ReturnCode = -2
			RETURN @ReturnCode
		END

		IF EXISTS
		(
			SELECT	1
			FROM	[dbo].[Product]
			WHERE	[Name] = @Name
			AND		[UomId] = @UomId
		)
		BEGIN
			SET @ReturnCode = -3
			RETURN @ReturnCode
		END

		IF @EntryTranCount = 0 
			BEGIN TRANSACTION

		INSERT	[dbo].[Product]
		(
			  [Name]
			, [IsShipped]
			, [CategoryId]
			, [AreaId]
			, [UomId]
			, [PriceUomId]
		)
		VALUES
		(
			  @Name
			, 0
			, @CategoryId
			, @AreaId
			, @UomId
			, ISNULL(@PriceUomId,@UomId)
		)

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
