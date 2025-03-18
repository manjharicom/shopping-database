CREATE TABLE [dbo].[Settings]
(
	  [SettingId]							INT					NOT NULL	IDENTITY(1,1)					
	, [Name]								NVARCHAR(50)		NOT NULL
	, [Value]								NVARCHAR(500)		NULL
	, CONSTRAINT [PK_settings_name] PRIMARY KEY CLUSTERED ([Name] ASC)
)
GO

CREATE UNIQUE INDEX	[UXSettingsName] ON [dbo].[Settings] ([Name] ASC) INCLUDE ([Value])
GO
