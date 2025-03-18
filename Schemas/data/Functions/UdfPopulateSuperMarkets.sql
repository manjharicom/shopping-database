CREATE FUNCTION [data].[UdfPopulateSuperMarkets]
(
	@SuperMarketId INT
)
RETURNS TABLE AS RETURN
(
	SELECT
			  [SuperMarketId]
			, [Name]
	FROM	(
				VALUES
					  (1 , 'PAKnSave Botany')
					, (2 , 'New World')
					, (3 , 'Countdown')
					, (4 , 'PAKnSave Flat Bush')
					, (5 , 'Fruit World Chapel Road')
			) AS Source 
			(
				  [SuperMarketId]
				, [Name]
			)
	WHERE	[SuperMarketId] = ISNULL(@SuperMarketId,[SuperMarketId])
)