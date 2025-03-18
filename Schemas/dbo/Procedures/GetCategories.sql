CREATE PROCEDURE [dbo].[GetCategories]
	@IncludeProducts	BIT = 0,
	@Categories			[dbo].[UdtId]	READONLY,
	@ReturnCode			INT		= NULL	OUT
AS
BEGIN
	--! Set output parameters.
	SET @ReturnCode = 0

	BEGIN TRY
		--! Reduce unnecessary network traffic and force rollback and aborting upon any error.
		SET NOCOUNT ON
		SET XACT_ABORT ON

		IF NOT EXISTS
		(
			SELECT	1
			FROM	@Categories
		)
		BEGIN
			SELECT	  c.[CategoryId]
					, c.[Name]
					, [ProductsJson] = [internal].[ProductsJson](c.[CategoryId], NULL, @IncludeProducts)
					, [IsShipped]
			FROM	[dbo].[Category] c
			ORDER BY c.[Name]
		END
		ELSE
		BEGIN
			SELECT	  c.[CategoryId]
					, c.[Name]
					, [ProductsJson] = [internal].[ProductsJson](c.[CategoryId], NULL, @IncludeProducts)
					, [IsShipped]
			FROM	[dbo].[Category] c
					CROSS APPLY @Categories ca
			WHERE	ca.[Id] = c.[CategoryId]
			ORDER BY c.[Name]
		END

		--! Return success.
		RETURN 0
	END TRY

	BEGIN CATCH
		IF @@trancount > 0 ROLLBACK TRANSACTION
		EXEC [internal].[CatchHandler] @proc_id = @@PROCID
		RETURN 55555
	END CATCH
END
