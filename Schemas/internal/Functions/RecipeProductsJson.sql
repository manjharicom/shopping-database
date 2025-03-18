CREATE FUNCTION [internal].[RecipeProductsJson]
(
	  @RecipeId			INT
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
	RETURN 
	(
		SELECT	  P.[ProductId]
				, p.[Name]
				, rp.[Measurement]
		FROM	[dbo].[Product] p
				INNER JOIN [dbo].[RecipeProduct] rp
					ON rp.[ProductId] = P.[ProductId]
		WHERE	rp.[RecipeId] = @RecipeId
		ORDER BY p.[Name]
				FOR JSON PATH
	)
END
