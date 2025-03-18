CREATE PROCEDURE [dbo].[GetProductsForCategory]
	  @CategoryId			INT
	, @ReturnCode			INT		= NULL	OUT
AS
BEGIN
	--! Set output parameters.
	SET @ReturnCode = 0

	BEGIN TRY
		--! Reduce unnecessary network traffic and force rollback and aborting upon any error.
		SET NOCOUNT ON
		SET XACT_ABORT ON

		SELECT	  [ProductId]
				, p.[Name]
				, [IsShipped]
				, p.[UomId]
				, [Uom] = u.[Name]
				, p.[PriceUomId]
				, [PriceUom] = u2.[Name]
		FROM	[dbo].[Product] P
				LEFT OUTER JOIN [dbo].[Uom] u
					ON p.[UomId] = u.[UomId]
				LEFT OUTER JOIN [dbo].[Uom] u2
					ON p.[PriceUomId] = u2.[UomId]
		WHERE	[CategoryId] = @CategoryId

		--! Return success.
		RETURN 0
	END TRY

	BEGIN CATCH
		IF @@trancount > 0 ROLLBACK TRANSACTION
		EXEC [internal].[CatchHandler] @proc_id = @@PROCID
		RETURN 55555
	END CATCH
END
