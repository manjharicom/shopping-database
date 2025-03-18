CREATE TABLE [admin].[StaticData]
(
	  [StaticDataId]	INT					NOT NULL
	, [SchemaName]		SYSNAME				NOT NULL
	, [TableName]		SYSNAME				NOT NULL
	, [Precedence]		TINYINT				NOT NULL
	, [IsTestData]		BIT					NOT	NULL	CONSTRAINT [DFStaticDataIsTestData] DEFAULT (0)
	, CONSTRAINT [PK_static_data] PRIMARY KEY CLUSTERED ([StaticDataId] ASC)
)
