CREATE TABLE [dbo].[ShoppingListProductPrice]
(
	  [ShoppingListProductPriceId]	INT				NOT	NULL	IDENTITY(1,1)
	, [ShoppingListPriceId]			INT				NOT	NULL
	, [ProductId]					INT				NOT	NULL
	, [DateCreated]					DATETIME		NOT NULL	CONSTRAINT [DF_ShoppingListProductPrice_DateCreated] DEFAULT (GETDATE())
	, [DateModified]				DATETIME		NOT NULL	CONSTRAINT [DF_ShoppingListProductPrice_DateModified] DEFAULT (GETDATE())
	, [Comment]						NVARCHAR(4000)	NULL
	, [Quantity]					DECIMAL(18,6)	NOT NULL
	, [Price]						DECIMAL(18,6)	NULL
    , [Total]						DECIMAL(18, 6)	NULL, 
    CONSTRAINT [PKShoppingListProductPrice] PRIMARY KEY CLUSTERED ([ShoppingListProductPriceId] ASC)
	, CONSTRAINT [FKShoppingListProductPriceShoppingListPriceId] FOREIGN KEY ([ShoppingListPriceId]) REFERENCES [dbo].[ShoppingListPrice] ([ShoppingListPriceId])
	, CONSTRAINT [FKShoppingListProductPriceProductId] FOREIGN KEY ([ProductId]) REFERENCES [dbo].[Product] ([ProductId])
)
GO

CREATE UNIQUE NONCLUSTERED INDEX [IX_ShoppingListPriceId_ProductId] ON [dbo].[ShoppingListProductPrice]
(
	  [ShoppingListPriceId] ASC
	, [ProductId] ASC
)
GO
