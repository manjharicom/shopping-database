CREATE PROCEDURE [dbo].[MergeCategorySuperMarket]
	  @SuperMarketId			INT
	, @CategorySuperMarkets		[dbo].[UdtCategorySuperMarket]	READONLY
	, @ReturnCode				INT								= NULL	OUT
AS
BEGIN
	--! Set output parameters.
	SET @ReturnCode = 0

	BEGIN TRY
		--! Reduce unnecessary network traffic and force rollback and aborting upon any error.
		SET NOCOUNT ON
		SET XACT_ABORT ON

		--! Locals.
		DECLARE @EntryTranCount				INT					= @@TRANCOUNT

		IF NOT EXISTS
		(
			SELECT	1
			FROM	@CategorySuperMarkets
		)
		BEGIN
			SET @ReturnCode = -1
			RETURN @ReturnCode
		END

		IF @EntryTranCount = 0 
			BEGIN TRANSACTION

		MERGE INTO [dbo].[CategorySuperMarket] AS Target
			USING
			(
				SELECT	
						  c.[CategoryId]
						, [SuperMarketId] = @SuperMarketId
						, c.[AisleLabel]
						, c.[Sequence]
				FROM	@CategorySuperMarkets c
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
			WHEN NOT MATCHED BY SOURCE
				AND Target.[SuperMarketId] = @SuperMarketId
				THEN
					DELETE
			;

		--! If we started the transaction then commit otherwise leave to caller.			
		IF @EntryTranCount = 0 
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
