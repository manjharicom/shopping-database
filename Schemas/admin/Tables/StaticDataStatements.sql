CREATE TABLE [admin].[StaticDataStatements]
(
	  [StaticDataId]						INT					NOT NULL
	, [Statement]							NVARCHAR(MAX)		NOT NULL
	, CONSTRAINT [PKStaticDataStatements] PRIMARY KEY CLUSTERED ([StaticDataId])
	, CONSTRAINT [FKStaticDataStatementsStaticDataId] FOREIGN KEY ([StaticDataId]) REFERENCES [admin].[StaticData] ([StaticDataId]) ON DELETE CASCADE
)
