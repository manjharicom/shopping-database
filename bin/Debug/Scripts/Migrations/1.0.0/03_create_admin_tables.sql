IF internal.ObjectExists('[admin].[StaticData]','U') = 0
BEGIN
CREATE TABLE [admin].[StaticData]
(
	  [StaticDataId]	INT					NOT NULL
	, [SchemaName]		SYSNAME				NOT NULL
	, [TableName]		SYSNAME				NOT NULL
	, [Precedence]		TINYINT				NOT NULL
	, [IsTestData]		BIT					NOT	NULL	CONSTRAINT [DFStaticDataIsTestData] DEFAULT (0)
	, CONSTRAINT [PK_static_data] PRIMARY KEY CLUSTERED ([StaticDataId] ASC)
)
END
GO

IF internal.ObjectExists('[admin].[StaticDataDependencies]','U') = 0
BEGIN
CREATE TABLE [admin].[StaticDataDependencies]
(
	  [StaticDataId] INT NOT NULL
	, [FunctionName]						SYSNAME				NOT NULL
	, CONSTRAINT [PKStaticDataDependencies] PRIMARY KEY CLUSTERED ([StaticDataId] ASC, [FunctionName] ASC)
)
END
GO

IF internal.ObjectExists('[admin].[StaticDataStatements]','U') = 0
BEGIN
CREATE TABLE [admin].[StaticDataStatements]
(
	  [StaticDataId]						INT					NOT NULL
	, [Statement]							NVARCHAR(MAX)		NOT NULL
	, CONSTRAINT [PKStaticDataStatements] PRIMARY KEY CLUSTERED ([StaticDataId])
	, CONSTRAINT [FKStaticDataStatementsStaticDataId] FOREIGN KEY ([StaticDataId]) REFERENCES [admin].[StaticData] ([StaticDataId]) ON DELETE CASCADE
)
END
GO

IF internal.ObjectExists('[dbo].[Settings]','U') = 0
BEGIN
CREATE TABLE [dbo].[Settings]
(
	  [SettingId]							INT					NOT NULL	IDENTITY(1,1)					
	, [Name]								NVARCHAR(50)		NOT NULL
	, [Value]								NVARCHAR(500)		NULL
	, CONSTRAINT [PK_settings_name] PRIMARY KEY CLUSTERED ([Name] ASC)
)

CREATE UNIQUE INDEX	[UXSettingsName] ON [dbo].[Settings] ([Name] ASC) INCLUDE ([Value])
END
GO
