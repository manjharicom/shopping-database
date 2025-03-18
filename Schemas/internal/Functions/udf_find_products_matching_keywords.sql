
/*
 * Purpose
 *		Locate products matching keywords supplied.
 * Information
 * Return Codes
 *		 0	- success
 *		-1	- one or more required parameters not supplied with value
 *		>0	- SQL Server error number
 * History
 *		Date		Person		Change
 *		-----------	-----------	------------------------------------------------
 */

CREATE FUNCTION [internal].[udf_find_products_matching_keywords]
(
	  @search_text			NVARCHAR(4000)
	, @category_id			INT
	, @area_Id			INT	
)
RETURNS @result TABLE
(
	  [ProductId]		INT
	, [CategoryId]		INT
	, [AreaId]			INT
	, [Name]			NVARCHAR(255)
	, [IsShipped]		BIT
	, [UomId]			INT
	, [PriceUomId]		INT
)
AS
BEGIN
	IF (NULLIF(LTRIM(RTRIM(@search_text)),N'') IS NULL)
	BEGIN
		INSERT INTO @result
			SELECT	  p.[ProductId]
					, p.[CategoryId]
					, p.[AreaId]
					, p.[Name]
					, p.[IsShipped]
					, p.[UomId]
					, p.[PriceUomId]
			FROM	[dbo].[Product] p
			WHERE	p.[CategoryId] = ISNULL(@category_id,p.[CategoryId])
			AND		p.[AreaId] = ISNULL(@area_Id,p.[AreaId])
	END
	ELSE
	BEGIN
		IF (NULLIF(LTRIM(RTRIM(@search_text)),N'') IS NULL)
			SET @search_text = '*'

		INSERT INTO @result
			SELECT	  p.[ProductId]
					, p.[CategoryId]
					, p.[AreaId]
					, p.[Name]
					, p.[IsShipped]
					, p.[UomId]
					, p.[PriceUomId]
			FROM	[dbo].[Product] p
			WHERE	p.[CategoryId] = ISNULL(@category_id,p.[CategoryId])
			AND		p.[AreaId] = ISNULL(@area_Id,p.[AreaId])
			AND		CONTAINS(Name,@search_text)			
	END
	RETURN;
END
