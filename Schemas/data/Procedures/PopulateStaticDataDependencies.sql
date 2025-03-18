CREATE PROCEDURE [data].[PopulateStaticDataDependencies]
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

		MERGE INTO [admin].[StaticDataDependencies] AS Target
			USING
				(
					VALUES
						  (100 , '[data].[UdfPopulateSuperMarkets]')
						, (200 , '[data].[UdfPopulateCategories]') 
						, (300 , '[data].[UdfPopulateAreas]') 
						, (400 , '[data].[UdfPopulateProducts]') 
						, (500 , '[data].[UdfPopulateCategorySuperMarket]') 
						, (600 , '[data].[UdfPopulateUom]') 
				) AS Source 
				(
						  [StaticDataId]
						, [FunctionName]
				)
			ON
				(
						Target.[StaticDataId] = Source.[StaticDataId]
					AND	Target.[FunctionName] = Source.[FunctionName]
				)
			WHEN NOT MATCHED BY TARGET THEN
				INSERT
				(
						  [StaticDataId]
						, [FunctionName]
				)
				VALUES
				(
						  Source.[StaticDataId]
						, Source.[FunctionName]
				)
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
