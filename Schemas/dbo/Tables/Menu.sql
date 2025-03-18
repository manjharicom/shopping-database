CREATE TABLE [dbo].[Menu]
(
	  [MenuId]				INT				NOT NULL 	IDENTITY(1,1)
	, [Name]				NVARCHAR(255)	NOT NULL
	, [CookingInstructions]	NVARCHAR(MAX)	NOT NULL
	, [DateCreated]			DATETIME		NOT NULL	CONSTRAINT [DF_Menu_DateCreated] DEFAULT (GETDATE())
	, [DateModified]		DATETIME		NOT NULL	CONSTRAINT [DF_Menu_DateModified] DEFAULT (GETDATE())
    , CONSTRAINT [PKMenuMenuId] PRIMARY KEY CLUSTERED ([MenuId] ASC)
)
