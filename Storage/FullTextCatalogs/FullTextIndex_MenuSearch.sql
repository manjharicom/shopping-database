CREATE FULLTEXT INDEX
	ON [dbo].[Menu]
		(Name)
	KEY INDEX [PKMenuMenuId]
	ON [FullTextCatalog_MenuSearch]
	WITH
		(
			STOPLIST [MenuSearch],
			CHANGE_TRACKING AUTO
		)
