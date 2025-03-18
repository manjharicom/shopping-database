CREATE TABLE [dbo].[BarCode]
(
	  [BarCodeId]	INT				NOT NULL	IDENTITY (1,1)
	, [BarCode]		NVARCHAR(255)	NOT NULL
	, [ProductId]	INT				NOT	NULL
	, CONSTRAINT [PKBarCodeBarCodeId] PRIMARY KEY CLUSTERED ([BarCodeId] ASC)
	, CONSTRAINT [FKBarCodeProductId] FOREIGN KEY ([ProductId]) REFERENCES [dbo].[Product] ([ProductId]) ON DELETE CASCADE
)
