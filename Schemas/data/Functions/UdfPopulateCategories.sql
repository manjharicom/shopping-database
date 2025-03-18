CREATE FUNCTION [data].[UdfPopulateCategories]
(
	@CategoryId INT
)
RETURNS TABLE AS RETURN
(
	SELECT
			  [CategoryId]
			, [Name]
			, [IsShipped]
	FROM	(
				VALUES
					  (1 , 'Vege', 1)
					, (2 , 'Butchery', 1)
					, (3 , 'Seafood', 1)
					, (4 , 'Deli', 1)
					, (5 , 'Bakery', 1)
					, (6 , 'Dairy and Eggs', 1)
					, (7 , 'Desserts', 1)
					, (8 , 'Frozen Vege', 1)
					, (9 , 'Baking', 1)
					, (10, 'Breakfast Cereals', 1)
					, (11, 'Canned Vege', 1)
					, (12, 'Canned Fruit', 1)
					, (13, 'Canned Other', 1)
					, (14, 'Sauces and Dressings', 1)
					, (15, 'Confectionary', 1)
					, (16, 'Drinks', 1)
					, (17, 'Jams, Spreads and Dips', 1)
					, (18, 'Pasta, Rice and Noodles', 1)
					, (19, 'Salad and Cooking Oils', 1)
					, (20, 'Snack Foods', 1)
					, (21, 'Spices and Seasonings', 1)
					, (22, 'Alcohol', 1)
					, (23, 'Oral Health', 1)
					, (24, 'Deoderants and Soaps', 1)
					, (25, 'Hair Care', 1)
					, (26, 'Face and Lip Care', 1)
					, (27, 'Suncare', 1)
					, (28, 'Cleaning', 1)
					, (29, 'Outdoor', 1)
					, (30, 'Laundry', 1)
					, (31, 'Fruit', 1)
					, (32, 'Nuts, Seeds and Lentils', 1)
					, (33, 'Biscuits', 1)
					, (34, 'Tissue', 1)
					, (35, 'Milks', 1)
					, (36, 'Frozen Fruit', 1)
					, (37, 'Medicines', 1)
					, (38, 'Customer Service', 1)
			) AS Source 
			(
				  [CategoryId]
				, [Name]
				, [IsShipped]
			)
	WHERE	[CategoryId] = ISNULL(@CategoryId,[CategoryId])
)