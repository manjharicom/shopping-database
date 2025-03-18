CREATE PROCEDURE [internal].[CatchHandler]
	  @proc_id								INT					= NULL
	, @reraise								BIT					= 1
	, @errno								INT					= NULL	OUTPUT
	, @errmsg								NVARCHAR(2048)		= NULL	OUTPUT
	, @errmsg_augmented						NVARCHAR(2048)		= NULL	OUTPUT
AS 
BEGIN
	BEGIN TRY
		--! Reduce unnecessary network traffic and force rollback and aborting upon any error.
		SET NOCOUNT ON
		SET XACT_ABORT ON

		--! Locals.
		DECLARE @me							SYSNAME				= OBJECT_SCHEMA_NAME(@proc_id) + '.' + OBJECT_NAME(@proc_id)					
		DECLARE @crlf						NCHAR(2)			= CHAR(13) + CHAR(10)
		DECLARE @msg						NVARCHAR(2048)
		DECLARE @severity					INT
		DECLARE @state						INT
		DECLARE @proc						SYSNAME
		DECLARE @errproc					SYSNAME
		DECLARE @lineno						INT
	           
	   --! Rollback if transaction in progress.
	   IF @@trancount > 0 ROLLBACK TRANSACTION

		SELECT	  @msg = ERROR_MESSAGE()
				, @severity = ERROR_SEVERITY()
				, @state  = ERROR_STATE()
				, @errno = ERROR_NUMBER()
				, @errproc = ERROR_PROCEDURE()
				, @lineno = ERROR_LINE()

		SELECT @proc = OBJECT_SCHEMA_NAME(@proc_id) + N'.' + OBJECT_NAME(@proc_id)
		SELECT @errmsg = @msg
		SELECT @errmsg_augmented = [internal].[FormatErrorMessage](@msg,@severity,@state,@errno,@errproc,@lineno,@proc)
	       
	END TRY

	BEGIN CATCH
	   --! Hopefully, this never occurs, but if it does, we try to produce both messages. 
	   SELECT @reraise = 1
	   SELECT @msg = @me + ERROR_MESSAGE() + @crlf + 'Original message: ' + @msg

	   --! Set ouptut variables if this has not been done.
	   IF @errmsg IS NULL SELECT @errmsg = @msg
	   IF @errmsg_augmented IS NULL SELECT @errmsg_augmented = @msg

	   -- Avoid new error if transaction is doomed.
	   IF xact_state() = -1 ROLLBACK TRANSACTION
	END CATCH

	--! Reaise if requested (or if an unexepected error occurred).
	IF @reraise = 1
		BEGIN
		   --! Adjust severity if needed; plain users cannot raise level 19.
		   IF @severity > 18 SELECT @severity = 18

		   --! Pass the message as a parameter to a parameter marker to avoid that
		   --! % chars cause problems.
		   RAISERROR('%s', @severity, @state, @errmsg_augmented)
		END
END
