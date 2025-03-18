CREATE TABLE [dbo].[Product]
(
	  [ProductId]		INT				NOT	NULL	IDENTITY(1,1)
	, [Name]			NVARCHAR(255)	NOT NULL
	, [IsShipped]		BIT				NOT NUll	CONSTRAINT [DF_Product_IsShipped] DEFAULT (0)
	, [DateCreated]		DATETIME		NOT NULL	CONSTRAINT [DF_Product_DateCreated] DEFAULT (GETDATE())
	, [DateModified]	DATETIME		NOT NULL	CONSTRAINT [DF_Product_DateModified] DEFAULT (GETDATE())
	, [CategoryId]		INT				NOT NULL
	, [AreaId]			INT				NOT NULL
	, [UomId]			INT				NOT NULL
	, [PriceUomId]		INT				NOT NULL
    , CONSTRAINT [PKProductProductId] PRIMARY KEY CLUSTERED ([ProductId] ASC)
	, CONSTRAINT [FKProductCategoryId] FOREIGN KEY ([CategoryId]) REFERENCES [dbo].[Category] ([CategoryId])
	, CONSTRAINT [FKProductAreaId] FOREIGN KEY ([AreaId]) REFERENCES [dbo].[Area] ([AreaId])
	, CONSTRAINT [FKProductUomId] FOREIGN KEY ([UomId]) REFERENCES [dbo].[Uom] ([UomId])
	, CONSTRAINT [FKProductPriceUomId] FOREIGN KEY ([PriceUomId]) REFERENCES [dbo].[Uom] ([UomId])
)
GO

CREATE UNIQUE NONCLUSTERED INDEX [IX_Product_Name_Uom] ON [dbo].[Product]
(
	  [Name] ASC
	, [UomId] ASC
)
GO
