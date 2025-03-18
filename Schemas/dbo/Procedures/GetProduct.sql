CREATE PROCEDURE [dbo].[GetProduct]
	  @ProductId			INT
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
				, p.[DateCreated]
				, p.[DateModified]
				, c.[CategoryId]
				, [Category] = c.[Name]
				, a.[AreaId]
				, [Area] = a.[Name]
				, [ShoppingListId] = [internal].[ExistsInShoppingList](p.[ProductId])
				, p.[IsShipped]
				, p.[UomId]
				, [Uom] = u.[Name]
				, p.[PriceUomId]
				, [PriceUom] = u2.[Name]
		FROM	[dbo].[Product] p
				INNER JOIN [dbo].Category c
					ON p.[CategoryId] = c.[CategoryId]
				INNER JOIN [dbo].[Area] a
					ON p.[AreaId] = a.[AreaId]
				LEFT OUTER JOIN [dbo].[Uom] u
					ON p.[UomId] = u.[UomId]
				LEFT OUTER JOIN [dbo].[Uom] u2
					ON p.[PriceUomId] = u2.[UomId]
		WHERE	[ProductId] = @ProductId

		--! Return success.
		RETURN 0
	END TRY

	BEGIN CATCH
		IF @@trancount > 0 ROLLBACK TRANSACTION
		EXEC [internal].[CatchHandler] @proc_id = @@PROCID
		RETURN 55555
	END CATCH
END
