CREATE PROCEDURE [admin].[ApplyStaticData]
	  @SchemaName							SYSNAME
	, @TableName							SYSNAME
	, @PrintCommands						BIT					= 0			--! values: 0=do not print sql, 1=print sql
	, @PrintCommandsOnly					BIT					= 0			--! values: 0=execute, 1=print only
	, @ReturnCode							INT					= NULL	OUT
AS
BEGIN
	--! Set output parameters now to avoid build issues.
	SET @ReturnCode = 0

	BEGIN TRY
		--! Reduce unnecessary network traffic and force rollback and aborting upon any error.
		SET NOCOUNT ON
		SET XACT_ABORT ON

		--! Locals.
		DECLARE @entry_tran_count			INT					= @@TRANCOUNT
		DECLARE @sql						NVARCHAR(MAX)

		--! Ensure have required parameters.
		IF @SchemaName IS NULL OR @TableName IS NULL 
			BEGIN
				SET @ReturnCode = -1
				RETURN @ReturnCode
			END

		--! Retrieve information to facilitate building of merge statement.
		SELECT
					@sql = sds.[Statement]
			FROM	[internal].[UdfGetStaticDataStatement](@SchemaName,@TableName) sds

		--! Ensure match found.
		IF @@ROWCOUNT <> 1
			BEGIN
				SET @ReturnCode = -3
				RETURN @ReturnCode
			END

		--! Start transaction unless one already exists.
		IF @entry_tran_count = 0
			BEGIN TRANSACTION

		--! Display and/or execute statement based on parameter.
		PRINT 'Populating table ' + [internal].[UdfGetObjectName](@SchemaName,@TableName)

		IF @PrintCommands = 1
			EXEC [internal].[LongPrint] @String = @sql

		IF @PrintCommandsOnly = 0
			EXEC sp_executesql @sql

		--! If we started the transaction then commit, unless in debug mode, otherwise leave to caller.			
		IF @entry_tran_count = 0
			COMMIT TRANSACTION

		--! Return success.
		RETURN 0
	END TRY

	BEGIN CATCH
		IF @@trancount > 0 ROLLBACK TRANSACTION
		EXEC [internal].[CatchHandler] @proc_id = @@PROCID
		RETURN 55555
	END CATCH
END
