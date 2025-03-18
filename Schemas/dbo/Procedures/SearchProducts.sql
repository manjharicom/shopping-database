CREATE PROCEDURE [dbo].[SearchProducts]
	  @SearchText		NVARCHAR(4000)		= NULL
	, @CategoryId		INT					= NULL
	, @AreaId			INT					= NULL
	, @ReturnCode		INT					= NULL	OUT
AS
BEGIN
	--! Set output parameters.
	SET @ReturnCode = 0

	BEGIN TRY
		--! Reduce unnecessary network traffic and force rollback and aborting upon any error.
		SET NOCOUNT ON
		SET XACT_ABORT ON

		SELECT	  p.[ProductId]
				, p.[Name]
				, [ShoppingListId] = [internal].[ExistsInShoppingList](p.[ProductId])
				, p.[IsShipped]
				, p.[UomId]
				, [Uom] = u.[Name]
				, p.[PriceUomId]
				, [PriceUom] = u2.[Name]
		FROM	[internal].[find_products](@SearchText, @CategoryId, @AreaId) p
				LEFT OUTER JOIN [dbo].[Uom] u
					ON p.[UomId] = u.[UomId]
				LEFT OUTER JOIN [dbo].[Uom] u2
					ON p.[PriceUomId] = u2.[UomId]
		--! Return success.
		RETURN 0
	END TRY

	BEGIN CATCH
		IF @@trancount > 0 ROLLBACK TRANSACTION
		EXEC [internal].[CatchHandler] @proc_id = @@PROCID
		RETURN 55555
	END CATCH
END
