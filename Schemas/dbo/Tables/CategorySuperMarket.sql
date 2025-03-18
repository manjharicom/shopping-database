CREATE TABLE [dbo].[CategorySuperMarket]
(
	  [CategorySuperMarketId]	INT					NOT	NULL	IDENTITY(1,1)
	, [CategoryId]				INT					NOT	NULL
	, [SuperMarketId]			INT					NOT	NULL
	, [AisleLabel]				NVARCHAR(250)		NULL
	, [Sequence]				INT					NULL
	, CONSTRAINT [PKCategorySuperMarketProductIdSuperMarketId] PRIMARY KEY CLUSTERED ([CategorySuperMarketId] ASC)
	, CONSTRAINT [FKCategorySuperMarketCategoryId] FOREIGN KEY ([CategoryId]) REFERENCES [dbo].[Category] ([CategoryId]) ON DELETE CASCADE
	, CONSTRAINT [FKCategorySuperMarketSuperMarketId] FOREIGN KEY ([SuperMarketId]) REFERENCES [dbo].[SuperMarket] ([SuperMarketId]) ON DELETE CASCADE
)
GO

CREATE UNIQUE NONCLUSTERED INDEX [IX_CategorySuperMarket] ON [dbo].[CategorySuperMarket]
(
	  [CategoryId] ASC
	, [SuperMarketId] ASC
)
GO
