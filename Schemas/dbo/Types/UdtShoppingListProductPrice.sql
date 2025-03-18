CREATE TYPE [dbo].[UdtShoppingListProductPrice] AS TABLE
(
	  [ProductId]	INT				NOT	NULL
	, [Comment]		NVARCHAR(4000)	NULL
	, [Quantity]	DECIMAL(18,6)	NOT NULL
	, [Price]		DECIMAL(18,6)	NOT NULL
	, [Total]		DECIMAL(18,6)	NOT NULL
)
