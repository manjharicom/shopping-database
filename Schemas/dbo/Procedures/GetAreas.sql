CREATE PROCEDURE [dbo].[GetAreas]
	@IncludeProducts	BIT = 0,
	@Areas				[dbo].[UdtId]	READONLY,
	@ReturnCode			INT		= NULL	OUT
AS
		IF NOT EXISTS
		(
			SELECT	1
			FROM	@Areas
		)
		BEGIN
			SELECT	  c.[AreaId]
					, c.[Name]
					, c.[IsShipped]
					, [ProductsJson] = [internal].[ProductsJson](NULL, c.[AreaId], @IncludeProducts)
					, [IsShipped]
			FROM	[dbo].[Area] c
			ORDER BY c.[Name]
		END
		ELSE
		BEGIN
			SELECT	  c.[AreaId]
					, c.[Name]
					, c.[IsShipped]
					, [ProductsJson] = [internal].[ProductsJson](NULL, c.[AreaId], @IncludeProducts)
					, [IsShipped]
			FROM	[dbo].[Area] c
					CROSS APPLY @Areas ca
			WHERE	ca.[Id] = c.[AreaId]
			ORDER BY c.[Name]
		END
RETURN 0
