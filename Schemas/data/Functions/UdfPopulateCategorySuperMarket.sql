CREATE FUNCTION [data].[UdfPopulateCategorySuperMarket]
(
)
RETURNS TABLE AS RETURN
(
	SELECT
			  [CategoryId]
			, [SuperMarketId]
			, [AisleLabel]
			, [Sequence]
	FROM	(
				VALUES
                       (1, 1, 'Fruit and Vege', 1)
                     , (2, 1, 'Butchery', 2)
                     , (3, 1, 'Seafood', 3)
                     , (4, 1, 'Delicatesan', 4)
                     , (5, 1, 'Bakery', 6)
                     , (6, 1, 'Dairy', 5)
                     , (7, 1, '7', 8)
                     , (8, 1, 'Frozen', 18)
                     , (9, 1, '8', 9)
                     , (10, 1, '10', 11)
                     , (11, 1, '7', 8)
                     , (12, 1, '7', 8)
                     , (13, 1, '7', 8)
                     , (14, 1, '11', 12)
                     , (15, 1, '13', 14)
                     , (16, 1, '5', 7)
                     , (17, 1, '11', 12)
                     , (18, 1, '9', 10)
                     , (19, 1, '9', 10)
                     , (20, 1, '13', 14)
                     , (21, 1, '11', 12)
                     , (22, 1, '17', 17)
                     , (23, 1, '14', 15)
                     , (24, 1, '14', 15)
                     , (25, 1, '14', 15)
                     , (26, 1, '14', 15)
                     , (27, 1, '14', 15)
                     , (28, 1, '12', 13)
                     , (29, 1, '13', 14)
                     , (30, 1, '12', 13)
                     , (31, 1, 'Fruit and Vege', 1)
                     , (32, 1, 'Bulk', 1)
                     , (33, 1, '15', 16)
                     , (34, 1, '14', 15)
                     , (35, 1, '7', 8)
                     , (36, 1, 'Frozen', 18)
                     , (37, 1, '14', 15)	
                     , (38, 1, 'Customer Service', 19)	
            ) AS Source 
			(
			      [CategoryId]
			    , [SuperMarketId]
			    , [AisleLabel]
			    , [Sequence]
			)
)
