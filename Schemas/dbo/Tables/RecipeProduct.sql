CREATE TABLE [dbo].[RecipeProduct]
(
	  [RecipeProductId]		INT				NOT	NULL	IDENTITY(1,1)
	, [RecipeId]			INT				NOT NULL
	, [ProductId]			INT				NOT	NULL
	, [Measurement]			NVARCHAR(4000)	NOT NULL
	, [DateCreated]			DATETIME		NOT NULL	CONSTRAINT [DF_RecipeProduct_DateCreated] DEFAULT (GETDATE())
	, [DateModified]		DATETIME		NOT NULL	CONSTRAINT [DF_RecipeProduct_DateModified] DEFAULT (GETDATE())
    , CONSTRAINT [PKRecipeProductRecipeProductId] PRIMARY KEY CLUSTERED ([RecipeProductId] ASC)
	, CONSTRAINT [FKRecipeProductRecipeId] FOREIGN KEY ([RecipeId]) REFERENCES [dbo].[Recipe] ([RecipeId])
	, CONSTRAINT [FKRecipeProductProductId] FOREIGN KEY ([ProductId]) REFERENCES [dbo].[Product] ([ProductId])
)
