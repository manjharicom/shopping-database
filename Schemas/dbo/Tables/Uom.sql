CREATE TABLE [dbo].[Uom]
(
	  [UomId]					INT				NOT NULL	IDENTITY(1,1)
	, [Name]					NVARCHAR(50)	NOT NULL
    , [AllowDecimalQuantity]	BIT				NOT NULL	CONSTRAINT [DF_Uom_AllowDecimalQuantity] DEFAULT (0)
    , CONSTRAINT [PKUom] PRIMARY KEY CLUSTERED ([UomId] ASC)
)
GO

CREATE UNIQUE NONCLUSTERED INDEX [IX_Uom_Description_Uom] ON [dbo].[Uom]
(
	  [Name] ASC
)
GO
