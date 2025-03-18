CREATE TABLE [dbo].[MenuRecipe]
(
	  [MenuRecipeId]	INT				NOT	NULL	IDENTITY(1,1)
	, [MenuId]			INT				NOT	NULL
	, [RecipeId]		INT				NOT NULL
	, [DateCreated]		DATETIME		NOT NULL	CONSTRAINT [DF_MenuRecipe_DateCreated] DEFAULT (GETDATE())
	, [DateModified]	DATETIME		NOT NULL	CONSTRAINT [DF_MenuRecipe_DateModified] DEFAULT (GETDATE())
    , CONSTRAINT [PKMenuRecipeMenuRecipeId] PRIMARY KEY CLUSTERED ([MenuRecipeId] ASC)
	, CONSTRAINT [FKMenuRecipeMenuId] FOREIGN KEY ([MenuId]) REFERENCES [dbo].[Menu] ([MenuId])
	, CONSTRAINT [FKMenuRecipeRecipeId] FOREIGN KEY ([RecipeId]) REFERENCES [dbo].[Recipe] ([RecipeId])
)
