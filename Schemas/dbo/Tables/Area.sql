CREATE TABLE [dbo].[Area]
(
	  [AreaId]			INT				NOT NULL
	, [Name]			NVARCHAR(255)	NOT NULL
	, [IsShipped]		BIT				NOT NUll	CONSTRAINT [DF_Area_IsShipped] DEFAULT (0)
	, [DateCreated]		DATETIME		NOT NULL	CONSTRAINT [DF_Area_DateCreated] DEFAULT (GETDATE())
	, [DateModified]	DATETIME		NOT NULL	CONSTRAINT [DF_Area_[DateModified] DEFAULT (GETDATE())
	, CONSTRAINT [PKAreaCategoryId] PRIMARY KEY CLUSTERED ([AreaId] ASC)
)
GO

CREATE UNIQUE NONCLUSTERED INDEX [IX_Area_Name] ON [dbo].[Area]
(
	[Name] ASC
)
GO
