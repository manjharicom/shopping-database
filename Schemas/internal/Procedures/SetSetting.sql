CREATE PROCEDURE [internal].[SetSetting]
	  @name									NVARCHAR(50)
	, @value								NVARCHAR(500)
	, @return_code							INT				= NULL	OUT
AS 
BEGIN
	--! Set output parameters.
	SET @return_code = 0

	BEGIN TRY
		--! Reduce unnecessary network traffic and force rollback and aborting upon any error.
		SET NOCOUNT ON
		SET XACT_ABORT ON

		--! Save requested setting.
		UPDATE s
			SET		value = @value
			FROM	[dbo].[Settings] s
			WHERE	s.[name] = @name

		--! Insert if not present.
		IF @@ROWCOUNT < 1
			BEGIN
				INSERT INTO [dbo].[settings]
					(
							  [name]
							, [value]
					)
					VALUES
					(
							  @name
							, @value
					)
			END

		--! Return success.
		RETURN 0
	END TRY

	BEGIN CATCH
		IF @@trancount > 0 ROLLBACK TRANSACTION
		EXEC [internal].[catch_handler] @@PROCID
		RETURN 55555
	END CATCH
END



