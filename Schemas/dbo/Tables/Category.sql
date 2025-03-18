CREATE TABLE [dbo].[Category]
(
	  [CategoryId]		INT				NOT	NULL
	, [Name]			NVARCHAR(255)	NOT NULL
	, [IsShipped]		BIT				NOT NUll	CONSTRAINT [DF_Category_IsShipped] DEFAULT (0)
	, [DateCreated]		DATETIME		NOT NULL	CONSTRAINT [DF_Category_DateCreated] DEFAULT (GETDATE())
	, [DateModified]	DATETIME		NOT NULL	CONSTRAINT [DF_Category_[DateModified] DEFAULT (GETDATE())
	, CONSTRAINT [PKCategoryCategoryId] PRIMARY KEY CLUSTERED ([CategoryId] ASC)
)
GO

CREATE UNIQUE NONCLUSTERED INDEX [IX_Category_Name] ON [dbo].[Category]
(
	[Name] ASC
)
GO
