CREATE TABLE [admin].[StaticDataDependencies]
(
	  [StaticDataId] INT NOT NULL
	, [FunctionName]						SYSNAME				NOT NULL
	, CONSTRAINT [PKStaticDataDependencies] PRIMARY KEY CLUSTERED ([StaticDataId] ASC, [FunctionName] ASC)
	, CONSTRAINT [FKStaticDataSDependencieStaticDataId] FOREIGN KEY ([StaticDataId]) REFERENCES [admin].[StaticData] ([StaticDataId]) ON DELETE CASCADE
)
