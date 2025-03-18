CREATE FUNCTION [internal].[MenuRecipesJson]
(
	  @MenuId			INT
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
	RETURN 
	(
		SELECT	  r.[RecipeId]
				, r.[Name]
				, r.[CookingInstructions]
				, [Products] = 
					(
						SELECT	  rp.[ProductId]
								, p.[Name]
								, rp.[Measurement]
						FROM	[dbo].[RecipeProduct] rp
								INNER JOIN dbo.[Product] p
									ON rp.[ProductId] = p.[ProductId]
						WHERE	rp.[RecipeId] = r.[RecipeId]
								FOR JSON PATH
					)
		FROM	[dbo].[Recipe] r
				INNER JOIN [dbo].[MenuRecipe] mp
					ON mp.[RecipeId] = r.[RecipeId]
		WHERE	mp.[MenuId] = @MenuId
		ORDER BY r.[Name]
				FOR JSON PATH
	)
END
