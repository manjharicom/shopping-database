CREATE FUNCTION [internal].[udf_find_menus_matching_keywords]
(
	@search_text			NVARCHAR(4000)
)
RETURNS @result TABLE
(
	  [MenuId]					INT
	, [Name]					NVARCHAR(255)
	, [CookingInstructions]		NVARCHAR(MAX)
)
AS
BEGIN
	IF (NULLIF(LTRIM(RTRIM(@search_text)),N'') IS NULL)
	BEGIN
		INSERT INTO @result
			SELECT	  p.[MenuId]
					, p.[Name]
					, p.[CookingInstructions]
			FROM	[dbo].[Menu] p
	END
	ELSE
	BEGIN
		IF (NULLIF(LTRIM(RTRIM(@search_text)),N'') IS NULL)
			SET @search_text = '*'

		INSERT INTO @result
			SELECT	  p.[MenuId]
					, p.[Name]
					, p.[CookingInstructions]
			FROM	[dbo].[Menu] p
			WHERE	CONTAINS([Name],@search_text)			
	END
	RETURN;
END