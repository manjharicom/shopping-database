CREATE PROCEDURE [data].[PopulateStaticDataStatements]
	  @return_code							INT					= NULL	OUT
AS
BEGIN
	--! Set output parameters now to avoid build issues.
	SET @return_code = 0

	BEGIN TRY
		--! Reduce unnecessary network traffic and force rollback and aborting upon any error.
		SET NOCOUNT ON
		SET XACT_ABORT ON

		--! Locals.
		DECLARE @entry_tran_count			INT					= @@TRANCOUNT

		--! Start transaction unless one already exists.
		IF @entry_tran_count = 0 
			BEGIN TRANSACTION

		MERGE INTO [admin].[StaticDataStatements] AS Target
			USING
				(
					VALUES
						  (100 , '
									MERGE INTO [dbo].[SuperMarket] AS Target
										USING
										(
											SELECT	
													  [SuperMarketId]
													, [Name]
											FROM	[data].[UdfPopulateSuperMarkets](NULL)
										) AS Source 
										ON
											(
													Target.[SuperMarketId] = Source.[SuperMarketId]
											)
										WHEN NOT MATCHED BY TARGET THEN
											INSERT
											(
													  [SuperMarketId]
													, [Name]
											)
											VALUES
											(
													  Source.[SuperMarketId]
													, Source.[Name]
											)
										WHEN MATCHED THEN
											UPDATE
											SET
													  [Name] = Source.[Name]
										;
						  ')
						, (200 , '
									MERGE INTO [dbo].[Category] AS Target
										USING
										(
											SELECT	
													  [CategoryId]
													, [Name]
													, [IsShipped]
											FROM	[data].[UdfPopulateCategories](NULL)
										) AS Source 
										ON
											(
													Target.[CategoryId] = Source.[CategoryId]
											)
										WHEN NOT MATCHED BY TARGET THEN
											INSERT
											(
													  [CategoryId]
													, [Name]
													, [IsShipped]
											)
											VALUES
											(
													  Source.[CategoryId]
													, Source.[Name]
													, Source.[IsShipped]
											)
										WHEN MATCHED THEN
											UPDATE
											SET
													  [Name] = Source.[Name]
													, [IsShipped] = Source.[IsShipped]
										WHEN NOT MATCHED BY SOURCE THEN
											DELETE
										;
						') 
						, (300 , '
									MERGE INTO [dbo].[Area] AS Target
										USING
										(
											SELECT	
													  [AreaId]
													, [Name]
													, [IsShipped]
											FROM	[data].[UdfPopulateAreas](NULL)
										) AS Source 
										ON
											(
													Target.[AreaId] = Source.[AreaId]
											)
										WHEN NOT MATCHED BY TARGET THEN
											INSERT
											(
													  [AreaId]
													, [Name]
													, [IsShipped]
											)
											VALUES
											(
													  Source.[AreaId]
													, Source.[Name]
													, Source.[IsShipped]
											)
										WHEN MATCHED THEN
											UPDATE
											SET
													  [Name] = Source.[Name]
													, [IsShipped] = Source.[IsShipped]
										WHEN NOT MATCHED BY SOURCE THEN
											DELETE
										;
						') 
						, (400 , '
									MERGE INTO [dbo].[Product] AS Target
										USING
										(
											SELECT	
													  [Name]
													, [IsShipped]
													, [CategoryId]
													, [AreaId]
											FROM	[data].[UdfPopulateProducts](NULL)
										) AS Source 
										ON
											(
													Target.[Name] = Source.[Name]
											)
										WHEN NOT MATCHED BY TARGET THEN
											INSERT
											(
													  [Name]
													, [IsShipped]
													, [CategoryId]
													, [AreaId]
											)
											VALUES
											(
													  Source.[Name]
													, Source.[IsShipped]
													, Source.[CategoryId]
													, Source.[AreaId]
											)
										WHEN MATCHED THEN
											UPDATE
											SET
													  [Name] = Source.[Name]
													, [IsShipped] = Source.[IsShipped]
													, [CategoryId] = Source.[CategoryId]
													, [AreaId] = Source.[AreaId]
										WHEN NOT MATCHED BY SOURCE 
											AND Target.IsShipped = 1
										THEN
											DELETE
										;
						')						
						, (500 , '
									MERGE INTO [dbo].[CategorySuperMarket] AS Target
										USING
										(
											SELECT	
													  [CategoryId]
													, [SuperMarketId]
													, [AisleLabel]
													, [Sequence]
											FROM	[data].[UdfPopulateCategorySuperMarket]()
										) AS Source 
										ON
											(
													Target.[CategoryId] = Source.[CategoryId]
													AND Target.[SuperMarketId] = Source.[SuperMarketId]
											)
										WHEN NOT MATCHED BY TARGET THEN
											INSERT
											(
													  [CategoryId]
													, [SuperMarketId]
													, [AisleLabel]
													, [Sequence]
											)
											VALUES
											(
													  Source.[CategoryId]
													, Source.[SuperMarketId]
													, Source.[AisleLabel]
													, Source.[Sequence]
											)
										WHEN MATCHED THEN
											UPDATE
											SET
													  [AisleLabel] = Source.[AisleLabel]
													, [Sequence] = Source.[Sequence]
										WHEN NOT MATCHED BY SOURCE THEN
											DELETE
										;
						')						
						, (600 , '
									MERGE INTO [dbo].[Uom] AS Target
										USING
										(
											SELECT	
													  [Name]
											FROM	[data].[UdfPopulateUom](NULL)
										) AS Source 
										ON
											(
													Target.[Name] = Source.[Name]
											)
										WHEN NOT MATCHED BY TARGET THEN
											INSERT
											(
													  [Name]
											)
											VALUES
											(
													  Source.[Name]
											)
										WHEN MATCHED THEN
											UPDATE
											SET
													  [Name] = Source.[Name]
										WHEN NOT MATCHED BY SOURCE THEN
											DELETE
										;
						')						
				) AS Source 
				(
						  [StaticDataId]
						, [Statement]
				)
			ON
				(
						Target.[StaticDataId] = Source.[StaticDataId]
				)
			WHEN NOT MATCHED BY TARGET THEN
				INSERT
				(
						  [StaticDataId]
						, [Statement]
				)
				VALUES
				(
						  Source.[StaticDataId]
						, Source.[Statement]
				)
			WHEN MATCHED THEN
				UPDATE 
					SET        
						  [Statement] = Source.[Statement]
			WHEN NOT MATCHED BY SOURCE THEN
				DELETE
			;

		--! If we started the transaction then commit otherwise leave to caller.			
		IF @entry_tran_count = 0 
			COMMIT
		
		--! Return success.
		RETURN 0
	END TRY

	BEGIN CATCH
		IF @@trancount > 0 ROLLBACK TRANSACTION
		EXEC [internal].[CatchHandler] @proc_id = @@PROCID
		RETURN 55555
	END CATCH
END
