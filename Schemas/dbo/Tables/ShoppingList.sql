CREATE TABLE [dbo].[ShoppingList]
(
	  [ShoppingListId]	INT				NOT	NULL	IDENTITY(1,1)
	, [SuperMarketId]	INT				NOT	NULL
	, [CheckListId]		NVARCHAR(50)	NOT NULL 
    , [Name]			NVARCHAR(50)	NOT NULL
	, [DateCreated]		DATETIME		NOT NULL	CONSTRAINT [DF_ShoppingList_DateCreated] DEFAULT (GETDATE())
	, [DateModified]	DATETIME		NOT NULL	CONSTRAINT [DF_ShoppingList_[DateModified] DEFAULT (GETDATE())
	, [BoardId]			NVARCHAR(50)	NOT NULL 
    , CONSTRAINT [PKShoppingList] PRIMARY KEY CLUSTERED ([ShoppingListId] ASC)
	, CONSTRAINT [FKShoppingListSuperMarketId] FOREIGN KEY ([SuperMarketId]) REFERENCES [dbo].[SuperMarket] ([SuperMarketId]) ON DELETE CASCADE
)
GO

CREATE UNIQUE NONCLUSTERED INDEX [IX_ShoppingList_SuperMarketId] ON [dbo].[ShoppingList]
(
	[SuperMarketId] ASC
)
GO
