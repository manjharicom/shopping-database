CREATE FULLTEXT INDEX
	ON [dbo].[Recipe]
		(Name)
	KEY INDEX [PKRecipeRecipeId]
	ON [FullTextCatalog_RecipeSearch]
	WITH
		(
			STOPLIST [RecipeSearch],
			CHANGE_TRACKING AUTO
		)
