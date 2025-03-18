CREATE PROCEDURE [data].[PopulateStaticData]
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

		MERGE INTO [admin].[StaticData] AS Target
			USING
				(
					VALUES
						  (100 , 'dbo', 'SuperMarket', 10, 0)
						, (200 , 'dbo', 'Category' , 10, 0) 
						, (300 , 'dbo', 'Area' , 10, 0) 
						, (400 , 'dbo', 'Product'  , 10, 0) 
						, (500 , 'dbo', 'CategorySuperMarket'  , 10, 0) 
						, (600 , 'dbo', 'Uom'  , 10, 0) 
				) AS Source 
				(
						  [StaticDataId]
						, [SchemaName]
						, [TableName]
						, [Precedence]
						, [IsTestData]
				)
			ON
				(
						Target.[StaticDataId] = Source.[StaticDataId]
				)
			WHEN NOT MATCHED BY TARGET THEN
				INSERT
				(
						  [StaticDataId]
						, [SchemaName]
						, [TableName]
						, [Precedence]
						, [IsTestData]
				)
				VALUES
				(
						  Source.[StaticDataId]
						, Source.[SchemaName]
						, Source.[TableName]
						, Source.[Precedence]
						, Source.[IsTestData]
				)
			WHEN MATCHED AND 
				(	
					SELECT	HASHBYTES
								(
									  'SHA1' 
									, (	
										SELECT	  
												  Source.[SchemaName]
												, Source.[TableName]
												, Source.[Precedence]
												, Source.[IsTestData]
										FOR XML RAW
									  )
								)
				) <>
				(	
					SELECT	HASHBYTES
								(
									  'SHA1' 
									, (	
										SELECT	  
												  Target.[SchemaName]
												, Target.[TableName]
												, Target.[Precedence]
												, Target.[IsTestData]
										FOR XML RAW
									  )
								)
				) THEN 
				UPDATE 
					SET        
						  [SchemaName] = Source.[SchemaName]
						, [TableName] = Source.[TableName]
						, [Precedence] = Source.[Precedence]
						, [IsTestData] = Source.[IsTestData]
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
