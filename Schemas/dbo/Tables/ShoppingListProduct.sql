CREATE TABLE [dbo].[ShoppingListProduct]
(
	  [ShoppingListProductId]	INT				NOT	NULL	IDENTITY(1,1)
	, [ShoppingListId]			INT				NOT NULL
	, [ProductId]				INT				NOT	NULL
	, [DateCreated]				DATETIME		NOT NULL	CONSTRAINT [DF_ShoppingListProduct_DateCreated] DEFAULT (GETDATE())
	, [DateModified]			DATETIME		NOT NULL	CONSTRAINT [DF_ShoppingListProduct_DateModified] DEFAULT (GETDATE())
	, [Comment]					NVARCHAR(4000)	NULL
	, [Quantity]				INT				NOT NULL	CONSTRAINT [DF_ShoppingListProduct_Quantity] DEFAULT (1)
	, [Purchased]				BIT				NOT NULL	CONSTRAINT [DF_ShoppingListProduct_Purchased] DEFAULT (0)
    , CONSTRAINT [PKShoppingListProduct] PRIMARY KEY CLUSTERED ([ShoppingListProductId] ASC)
	, CONSTRAINT [FKShoppingListProductShoppingListId] FOREIGN KEY ([ShoppingListId]) REFERENCES [dbo].[ShoppingList] ([ShoppingListId]) ON DELETE CASCADE
	, CONSTRAINT [FKShoppingListProductProductId] FOREIGN KEY ([ProductId]) REFERENCES [dbo].[Product] ([ProductId]) ON DELETE CASCADE
)
GO
