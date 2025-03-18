CREATE TABLE [dbo].[Recipe]
(
	  [RecipeId]			INT				NOT NULL 	IDENTITY(1,1)
	, [Name]				NVARCHAR(255)	NOT NULL
	, [CookingInstructions]	NVARCHAR(MAX)	NOT NULL
	, [DateCreated]			DATETIME		NOT NULL	CONSTRAINT [DF_Recipe_DateCreated] DEFAULT (GETDATE())
	, [DateModified]		DATETIME		NOT NULL	CONSTRAINT [DF_Recipe_DateModified] DEFAULT (GETDATE())
    , CONSTRAINT [PKRecipeRecipeId] PRIMARY KEY CLUSTERED ([RecipeId] ASC)
)
