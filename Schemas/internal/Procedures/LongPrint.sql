CREATE PROCEDURE [internal].[LongPrint]
	  @String								NVARCHAR(MAX)
AS
BEGIN
	BEGIN TRY
		--! Reduce unnecessary network traffic and force rollback and aborting upon any error.
		SET NOCOUNT ON
		SET XACT_ABORT ON

		--! Locals.
		DECLARE @entry_tran_count			INT					= @@TRANCOUNT
		DECLARE @me							NVARCHAR(50)		= OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID)				
		DECLARE @current_end				BIGINT								--! track the length of the next substring
		DECLARE @offset						TINYINT								--! tracks the amount of offset needed

		SET @string = REPLACE(REPLACE(@string, CHAR(13) + CHAR(10), CHAR(10)) , CHAR(13), CHAR(10))

		WHILE LEN(@string) > 1 
			BEGIN
				IF CHARINDEX(CHAR(10), @string) BETWEEN 1 AND 4000
					BEGIN
						SET @current_end = CHARINDEX(CHAR(10), @string) - 1
						SET @offset = 2
					END
				ELSE
					BEGIN
						SET @current_end = 4000
						SET @offset = 1
					END   
 
				PRINT SUBSTRING(@string, 1, @current_end) 
 
				SET @string = SUBSTRING(@string, @current_end+@offset, 1073741822)   
			END
	END TRY

	BEGIN CATCH
		IF @@trancount > 0 ROLLBACK TRANSACTION
		EXEC [internal].[CatchHandler] @@PROCID
		RETURN 55555
	END CATCH
END
