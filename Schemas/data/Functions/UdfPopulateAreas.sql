CREATE FUNCTION [data].[UdfPopulateAreas]
(
	@AreaId INT
)
RETURNS TABLE AS RETURN
(
	SELECT
			  [AreaId]
			, [Name]
			, [IsShipped]
	FROM	(
				VALUES
					  (1, 'Fridge', 1)
					, (2, 'Freezer', 1)
					, (3, 'Kitchen Pantry', 1)
					, (4, 'Kitchen Cleaners', 1)
					, (5, 'Lounge', 1)
					, (6, 'Laundry', 1)
					, (7, 'Bathroom', 1)
					, (8, 'Garage', 1)
					, (9, 'Bedroom', 1)
			) AS Source 
			(
				  [AreaId]
				, [Name]
				, [IsShipped]
			)
	WHERE	[AreaId] = ISNULL(@AreaId,[AreaId])
)
GO
