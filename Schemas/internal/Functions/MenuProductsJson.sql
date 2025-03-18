CREATE FUNCTION [internal].[MenuProductsJson]
(
	  @MenuId			INT
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
				INNER JOIN [dbo].[MenuProduct] rp
					ON rp.[ProductId] = P.[ProductId]
		WHERE	rp.[MenuId] = @MenuId
		ORDER BY p.[Name]
				FOR JSON PATH
	)
END
