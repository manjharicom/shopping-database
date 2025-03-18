CREATE PROCEDURE [dbo].[GetCategorySuperMarkets]
	  @SuperMarketId			INT
	, @ReturnCode				INT								= NULL	OUT
AS
BEGIN
	--! Set output parameters.
	SET @ReturnCode = 0

	BEGIN TRY
		--! Reduce unnecessary network traffic and force rollback and aborting upon any error.
		SET NOCOUNT ON
		SET XACT_ABORT ON

		SELECT	  c.[CategoryId]
				, [Category] = c.[Name]
				, csm.[AisleLabel]
				, csm.[Sequence]
		FROM	[dbo].[Category] c
				LEFT OUTER JOIN [dbo].[CategorySuperMarket] csm
					ON csm.[CategoryId] = c.[CategoryId]
					AND	csm.[SuperMarketId]	= @SuperMarketId
		ORDER BY c.[Name]

		--! Return success.
		RETURN 0
	END TRY

	BEGIN CATCH
		IF @@trancount > 0 ROLLBACK TRANSACTION
		EXEC [internal].[CatchHandler] @proc_id = @@PROCID
		RETURN 55555
	END CATCH
END
