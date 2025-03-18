CREATE TYPE [dbo].[UdtRecipeProduct] AS TABLE
(
	  [ProductId]		INT
	, [Name]			NVARCHAR(255)
	, [Measurement]		NVARCHAR(4000)
)