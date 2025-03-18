CREATE TABLE [dbo].[ShoppingListPrice]
(
	  [ShoppingListPriceId]			INT				NOT NULL	IDENTITY(1,1)
	, [ShoppingListId]				INT				NOT NULL
	, [ShoppingDate]				DATETIME		NOT NULL
	, [DateCreated]					DATETIME		NOT NULL	CONSTRAINT [DF_ShoppingListPrice_DateCreated] DEFAULT (GETDATE())
	, [DateModified]				DATETIME		NOT NULL	CONSTRAINT [DF_ShoppingListPrice_DateModified] DEFAULT (GETDATE())
    , CONSTRAINT [PKShoppingListPrice] PRIMARY KEY CLUSTERED ([ShoppingListPriceId] ASC)
	, CONSTRAINT [FKShoppingListPriceShoppingListId] FOREIGN KEY ([ShoppingListId]) REFERENCES [dbo].[ShoppingList] ([ShoppingListId])
)
GO
