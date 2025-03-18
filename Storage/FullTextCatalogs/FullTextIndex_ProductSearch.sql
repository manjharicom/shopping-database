CREATE FULLTEXT INDEX
	ON [dbo].[Product]
		(Name)
	KEY INDEX [PKProductProductId]
	ON [FullTextCatalog_ProductSearch]
	WITH
		(
			STOPLIST [ProductSearch],
			CHANGE_TRACKING AUTO
		)
