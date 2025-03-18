CREATE PROCEDURE [dbo].[GetSuperMarkets]
	@SuperMarkets		[dbo].[UdtId]	READONLY,
	@ReturnCode			INT		= NULL	OUT
AS
BEGIN
	--! Set output parameters.
	SET @ReturnCode = 0

	BEGIN TRY
		--! Reduce unnecessary network traffic and force rollback and aborting upon any error.
		SET NOCOUNT ON
		SET XACT_ABORT ON

		IF NOT EXISTS
		(
			SELECT	1
			FROM	@SuperMarkets
		)
		BEGIN
			SELECT	  [SuperMarketId]
					, [Name]
			FROM	[dbo].[SuperMarket]
		END
		ELSE
		BEGIN
			SELECT	  [SuperMarketId]
					, [Name]
			FROM	[dbo].[SuperMarket] c
					CROSS APPLY @SuperMarkets ca
			WHERE	ca.[Id] = c.[SuperMarketId]
			ORDER BY c.[Name]
		END

		--! Return success.
		RETURN 0
	END TRY

	BEGIN CATCH
		IF @@trancount > 0 ROLLBACK TRANSACTION
		EXEC [internal].[CatchHandler] @proc_id = @@PROCID
		RETURN 55555
	END CATCH
END
