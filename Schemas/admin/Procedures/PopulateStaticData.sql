CREATE PROCEDURE [admin].[PopulateStaticData]
	  @ChangesOnly			BIT					= 1			--! true only apply modified data changes and false to populate everything
	, @ChangePeriod			INT					= 1			--! number of hours to consider changed
	, @TestDataOnly			BIT					= 0			--! trune to apply test data only
	, @StaticDataId			INT					= NULL		--! execute specific table only
	, @PrintCommands		BIT					= 0			--! values: 0=do not print sql, 1=print sql
	, @PrintCommandsOnly	BIT					= 0			--! values: 0=execute, 1=print only
	, @ReturnCode			INT					= NULL	OUT
AS
BEGIN
	--! Set output parameters now to avoid build issues.
	SET @ReturnCode = 0

	BEGIN TRY
		--! Reduce unnecessary network traffic and force rollback and aborting upon any error.
		SET NOCOUNT ON
		SET XACT_ABORT ON

		--! Locals.
		DECLARE @EntryTranCount			INT					= @@TRANCOUNT
		DECLARE @SchemaName				SYSNAME
		DECLARE @TableName					SYSNAME
		DECLARE @Sql						NVARCHAR(MAX)
		DECLARE @Params						NVARCHAR(MAX)
		DECLARE @Now						DATETIME2			= GETDATE()	--! Needs to be system rather than local time.
		DECLARE @LastPopulateTime			DATETIME2			= [internal].[GetPopulateSetting]()
		DECLARE @procedure					SYSNAME
		DECLARE @tables						TABLE
			(
				  [SchemaName]				SYSNAME
				, [TableName]				SYSNAME
				, [Precedence]				TINYINT
			)

		--! Set change period to number of hours earlier.
		SET @LastPopulateTime = ISNULL(@LastPopulateTime,DATEADD(HOUR,ISNULL(@ChangePeriod,1) * -1,@Now))

		--! Start transaction unless one already exists.
		IF @EntryTranCount = 0 
			BEGIN TRANSACTION

		EXEC [data].[PopulateStaticData]
		EXEC [data].[PopulateStaticDataStatements]
		EXEC [data].[PopulateStaticDataDependencies]

		--! Execute all or modified data in precence order.
		--! Do not deploy test data to production environments.
		IF @StaticDataId IS NOT NULL
			BEGIN
				INSERT INTO @tables
					(
							  [SchemaName]
							, [TableName]
							, [precedence]
					)
					SELECT	
							  sd.[SchemaName]
							, sd.[TableName]
							, sd.[Precedence]
					FROM	[admin].[StaticData] sd
					WHERE	sd.[StaticDataId] = @StaticDataId
					 AND	[IsTestData] = 0 
			END
		ELSE
			BEGIN
				INSERT INTO @tables
					(
							  [SchemaName]
							, [TableName]
							, [Precedence]
					)
					SELECT	
							  sd.[SchemaName]
							, sd.[TableName]
							, sd.[Precedence]
					FROM	[admin].[StaticData] sd
					WHERE	( @ChangesOnly = 0
						OR	  EXISTS
								(
									SELECT	1
									FROM	[admin].[StaticDataDependencies] sdd
											CROSS APPLY [internal].[SplitObjectName](sdd.[FunctionName]) pn
											INNER JOIN [internal].[GetModifiedCode]() mc
												ON	mc.[SchemaName] = pn.[SchemaName]
												AND	mc.[ObjectName] = pn.[ObjectName]
									WHERE	sdd.[StaticDataId] = sd.[StaticDataId]
										AND	mc.[modify_date] >= @LastPopulateTime
								)
							)
					 AND	[IsTestData] >= @TestDataOnly
					 AND	[IsTestData] = 0 
			END

		--! Process in sequence.
		DECLARE csr CURSOR LOCAL FAST_FORWARD READ_ONLY FOR 
			SELECT	
					  [SchemaName]
					, [TableName]
			FROM	@tables
			ORDER BY
					  [Precedence]
					, [SchemaName]
					, [TableName]

		OPEN csr
		FETCH NEXT FROM csr INTO @SchemaName, @TableName
		WHILE @@FETCH_STATUS = 0
			BEGIN
				SET @Sql = N'EXEC [Admin].[ApplyStaticData] @SchemaName = ' + @SchemaName + N' , @TableName = ' + @TableName + N', @PrintCommands = ' + CONVERT(NVARCHAR,@PrintCommands)  + N', @PrintCommandsOnly = ' + CONVERT(NVARCHAR,@PrintCommandsOnly)
				SET @Params = N''

				EXEC sp_executesql @stmt = @Sql, @Params = @Params

				FETCH NEXT FROM csr INTO @SchemaName, @TableName
			END
		CLOSE csr
		DEALLOCATE csr

		--! Capture successful run.
		EXEC [internal].[SetSetting]
			  @name = N'Populate'
			, @value = @Now

		--! If we started the transaction then commit otherwise leave to caller.			
		IF @EntryTranCount = 0 
			COMMIT

		--! Return success.
		RETURN 0
	ErrorExit:
		--! Raise error condition.
		RAISERROR('Procedure %s returned error code %d', 16, 0, @procedure, @ReturnCode)

	END TRY

	BEGIN CATCH
		IF @@trancount > 0 ROLLBACK TRANSACTION
		EXEC [internal].[CatchHandler] @proc_id = @@PROCID
		RETURN 55555
	END CATCH
END
