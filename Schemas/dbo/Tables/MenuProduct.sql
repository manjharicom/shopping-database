CREATE TABLE [dbo].[MenuProduct]
(
	  [MenuProductId]		INT				NOT	NULL	IDENTITY(1,1)
	, [MenuId]				INT				NOT NULL
	, [ProductId]			INT				NOT	NULL
	, [Measurement]			NVARCHAR(4000)	NOT NULL
	, [DateCreated]			DATETIME		NOT NULL	CONSTRAINT [DF_MenuProduct_DateCreated] DEFAULT (GETDATE())
	, [DateModified]		DATETIME		NOT NULL	CONSTRAINT [DF_MenuProduct_DateModified] DEFAULT (GETDATE())
    , CONSTRAINT [PKMenuProductMenuProductId] PRIMARY KEY CLUSTERED ([MenuProductId] ASC)
	, CONSTRAINT [FKMenuProductMenuId] FOREIGN KEY ([MenuId]) REFERENCES [dbo].[Menu] ([MenuId])
	, CONSTRAINT [FKMenuProductProductId] FOREIGN KEY ([ProductId]) REFERENCES [dbo].[Product] ([ProductId])
)
