CREATE FUNCTION [data].[UdfPopulateProducts]
(
	@Name NVARCHAR(255)
)
RETURNS TABLE AS RETURN
(
	SELECT
			  [Name]
			, [IsShipped]
			, [CategoryId]
			, [AreaId]
	FROM	(
				VALUES
					--!Fridge
					--!Vege
					  ('Broccoli', 1, 1, 1)
					, ('Cauliflower', 1, 1, 1)
					, ('Cabbage', 1, 1, 1)
					, ('Spring Onions', 1, 1, 1)
					, ('White Onions', 1, 1, 1)
					, ('Red Onions', 1, 1, 1)
					, ('Garlic', 1, 1, 1)
					, ('Ginger', 1, 1, 1)
					, ('Aubergine', 1, 1, 1)
					, ('Carrots', 1, 1, 1)
					, ('Lettuce', 1, 1, 1)
					, ('Tomatoes', 1, 1, 1)
					, ('Avocado', 1, 1, 1)
					, ('Salad', 1, 1, 1)

					--!Fruit
					, ('Brae Burn Apples', 1, 31, 1)
					, ('Granny Smith Apples', 1, 31, 1)
					, ('Oranges', 1, 31, 1)
					, ('Pears', 1, 31, 1)
					, ('Mandarins', 1, 31, 1)
					, ('Apricots', 1, 31, 1)
					, ('Peaches', 1, 31, 1)
					, ('Nectarines', 1, 31, 1)
					, ('Red Grapes', 1, 31, 1)
					, ('White Grapes', 1, 31, 1)
					, ('Strawberries', 1, 31, 1)
					, ('Lemons', 1, 31, 1)
					, ('Courgette', 1, 31, 1)
					, ('Peppers', 1, 31, 1)

					--!Seafood
					, ('Salmon', 1, 3, 1)
					, ('Terakihi', 1, 3, 1)
					, ('Gurnard', 1, 3, 1)

					, ('Eggs',1, 6, 1)

					, ('Mayonaise',1, 14, 1)
					, ('Aioli',1, 14, 1)
					, ('Salad Dressing',1, 14, 1)
					, ('Tomato Sauce',1, 14, 1)
					, ('Burger Sauce',1, 14, 1)
					, ('Mustard',1, 14, 1)
					, ('Maple Syrup',1, 14, 1)
					, ('Srircha Mayonaise Sauce',1, 14, 1)
					, ('SoySauce',1, 14, 1)

					--!Alcohol
					, ('White Wine', 1, 22, 1)
					, ('Red Wine', 1, 22, 1)
					, ('Beer', 1, 22, 1)
					, ('Gin', 1, 22, 1)

					, ('Vogels Gluten Free Bread Soy/Linseed',1, 5, 1)
					, ('Bread',1, 5, 1)
					, ('Wraps',1, 5, 1)
					, ('Croisants',1, 5, 1)
					, ('Baby Spinach',1, 1, 1)
					, ('Spinach',1, 1, 1)
					, ('Pasta Ready Made',1, 4, 1)
					, ('Green Beans',1, 1, 1)

					, ('Milk Blue 3l',1, 6, 1)
					, ('Milk Blue 2l',1, 6, 1)
					, ('Cream',1, 6, 1)
					, ('Yoghurt Pottle',1, 6, 1)
					, ('Butter',1, 6, 1)
					, ('Butter Spreadable',1, 6, 1)
					, ('Olivani',1, 6, 1)
					, ('Cheese Tasty',1, 6, 1)
					, ('Cheese Parmesan',1, 6, 1)
					, ('Paneer',1, 6, 1)

					, ('Filter Coffee',1, 16, 1)

					, ('Green Pesto Dip',1, 17, 1)
					, ('Green Pesto',1, 17, 1)
					, ('Mediterranean Dip',1, 17, 1)
					, ('Red Pepper Dip',1, 17, 1)
					, ('Other Dips',1, 17, 1)
					, ('Hummus',1, 17, 1)

					--!FREEZER
					--Meat
					, ('Chicken Legs', 1, 2, 2)
					, ('Chicken Thighs', 1, 2, 2)
					, ('Chicken Breast', 1, 2, 2)
					, ('Chicken Tenders', 1, 2, 2)
					, ('Sausages', 1, 2, 2)

					--Seafood
					, ('Prawns', 1, 3, 2)

					--Bakery
					, ('Short Crust Pastry', 1, 5, 2)

					--Frozen Vege
					, ('Frozen Hash Browns',1, 8, 2)
					, ('Frozen Chips',1, 8, 2)
					, ('Frozen Wedges',1, 8, 2)
					, ('Frozen Sweet Corn',1, 8, 2)
					, ('Frozen Green Beans',1, 8, 2)
					, ('Frozen Oriental Stir Fry',1, 8, 2)
					, ('Frozen Classic Stir Fry',1, 8, 2)
					, ('Frozen Mixed Vege',1, 8, 2)
					, ('Frozen Chilli',1, 8, 2)
					, ('Frozen Spinach',1, 8, 2)
					, ('Frozen Peas',1, 8, 2)
					, ('Frozen Mixed Peppers',1, 8, 2)

					--Frozen Fruit
					, ('Frozen Mango',1, 36, 2)
					, ('Frozen Blueberries',1, 36, 2)
					, ('Frozen Strawberries',1, 36, 2)
					, ('Frozen Passionfruit',1, 36, 2)
					, ('Frozen Tropical Smoothie',1, 36, 2)
					, ('Frozen Smoothie Mix',1, 36, 2)
					, ('Ice Cream',1, 6, 2)

					--!PANTRY
					--Vege
					, ('Potatoes', 1, 1, 3)
					, ('Kumara', 1, 1, 3)
					, ('Pumpkin', 1, 1, 3)

					--Fruit
					, ('Pineapple',1, 31, 3)
					, ('Mango',1, 31, 3)
					, ('Cranberries', 1, 31, 1)
					, ('Pitted Dates', 1, 31, 1)

					--Bakery
					, ('Sugar - John',1, 5, 3)
					, ('Sugar - Raw',1, 5, 3)
					, ('Sugar - Castor',1, 5, 3)
					, ('Sugar - Dark Brown',1, 5, 3)
					, ('Plain Flour',1, 5, 3)
					, ('Self Raising Flour',1, 5, 3)
					, ('Gram Flour',1, 5, 3)
					, ('Chickpea Flour',1, 5, 3)
					, ('Rice Flour',1, 5, 3)
					, ('Chapati Flour',1, 5, 3)

					--Baking
					, ('Panko Breadcrumbs',1, 9, 3)
					, ('Dessicated Coconut',1, 9, 3)
					, ('Cocoa Powder',1, 9, 3)
					, ('Oat Bran',1, 9, 3)

					--Breakfast Cereals
					, ('Wheetbix',1, 10, 3)
					, ('Oats',1, 10, 3)
					, ('Muesli',1, 10, 3)

					--Tinned
					, ('Cannelini Beans Tinned',1, 11, 3)
					, ('Four Bean Mix Tinned',1, 11, 3)
					, ('Tomatos Tinned',1, 11, 3)
					, ('Kidney Beans Tinned',1, 11, 3)
					, ('Chickpeas Tinned',1, 11, 3)
					, ('Black Beans Tinned',1, 11, 3)
					, ('Baked Beans Tinned',1, 11, 3)
					, ('Beetroot Tinned',1, 11, 3)

					, ('Pineapple Tinned',1, 12, 3)
					, ('Pasta Sauce Tinned',1, 12, 3)
					, ('Coconut Milk Tinned',1, 12, 3)
					, ('Condensed Milk Tinned',1, 12, 3)

					--Sauces
					, ('Sriracha Sauce',1, 14, 3)
					, ('Worcestershire Sauce',1, 14, 3)
					, ('White Vinegar',1, 14, 3)
					, ('Rice Wine Vinegar',1, 14, 3)
					, ('Apple Cider Vinegar',1, 14, 3)

					--Confectionary
					, ('Crisps',1, 15, 3)
					, ('Doritos',1, 15, 3)
					, ('Chocolate',1, 15, 3)
					, ('Whittakers Peanut Slab',1, 15, 3)

					--Drinks
					, ('Orange Juice',1, 16, 3)
					, ('Apple Juice',1, 16, 3)
					, ('Orange and Mango Juice',1, 16, 3)
					, ('Instant Coffee',1, 16, 3)
					, ('Hot Chocolate',1, 16, 3)
					, ('Milo',1, 16, 3)
					, ('Soda Water',1, 16, 3)
					, ('Tonic Water',1, 16, 3)
					, ('Coke',1, 16, 3)
					, ('Fanta',1, 16, 3)
					, ('Lemonade',1, 16, 3)
					, ('L&P',1, 16, 3)
					, ('Dilmah Tea Bags',1, 16, 3)
					, ('Herbal Tea Bags',1, 16, 3)
					, ('Weight Gain',1, 16, 3)
					, ('Metamucil',1, 16, 3)

					--Jams, Spreads and Dips
					, ('Strawberry Jam',1, 17, 3)
					, ('Marmalade Jam',1, 17, 3)
					, ('Peanut Butter',1, 17, 3)
					, ('Anathoth Pickle',1, 17, 3)
					, ('Honey',1, 17, 3)

					--Pasta, Rice and Noodles
					, ('Pasta - Boccoli',1, 18, 3)
					, ('Pasta - Spaghetti',1, 18, 3)
					, ('Pasta - Lasagna',1, 18, 3)
					, ('Pasta - Canneloni',1, 18, 3)
					, ('Maggi Chicken Noodles',1, 18, 3)
					, ('Chinese Egg Noodles',1, 18, 3)
					, ('Indomie Noodles',1, 18, 3)
					, ('Pot Noodles',1, 18, 3)
					, ('Jasmine Rice',1, 18, 3)
					, ('Basmati Rice',1, 18, 3)
					, ('Poha',1, 18, 3)
					, ('Popadoms',1, 18, 3)

					--Salad and Cooking Oils
					, ('Pams Extra Virgin Olive Oil',1, 19, 3)
					, ('Avocado Oil',1, 19, 3)
					, ('Infused Olive Oil',1, 19, 3)

					--Snack Foods
					, ('Crackers',1, 20, 3)
					, ('Nut Bars',1, 20, 3)

					--Spices
					, ('Table Salt',1, 21, 3)
					, ('Himalayan Pink Salt',1, 21, 3)
					, ('Sea Salt',1, 21, 3)
					, ('Ground Pepper',1, 21, 3)
					, ('Pepper Corns',1, 21, 3)
					, ('Mustard Powder',1, 21, 3)
					, ('Roast Chicken Spice',1, 21, 3)
					, ('Ground Cinnamon',1, 21, 3)
					, ('Ground Nutmeg',1, 21, 3)
					, ('Cloves',1, 21, 3)
					, ('Garlic Granules',1, 21, 3)
					, ('Cayenne Pepper',1, 21, 3)
					, ('Italian Herbs',1, 21, 3)
					, ('Roast Vege Seasoning',1, 21, 3)
					, ('Ground Paprika',1, 21, 3)
					, ('Chilli Powder',1, 21, 3)
					, ('Bisto Gravy Mix',1, 21, 3)
					, ('Vege Stock Powder',1, 21, 3)
					, ('Chana Masala',1, 21, 3)
					, ('Sambar Powder',1, 21, 3)
					, ('Masala Powder',1, 21, 3)
					, ('Mixed Herbs',1, 21, 3)
					, ('Pulao Masala',1, 21, 3)

					--!Nuts and Seeds
					, ('Sunflower Seeds', 1, 32, 3)
					, ('Pumpkin Seeds', 1, 32, 3)
					, ('Chia Seeds', 1, 32, 3)
					, ('Sesame Seeds', 1, 32, 3)
					, ('Flax/Linseed Seeds', 1, 32, 3)
					, ('Masoor Whole',1, 32, 3)
					, ('Urad Gota',1, 32, 3)
					, ('Urad Whole',1, 32, 3)
					, ('Red Lentils',1, 32, 3)
					, ('Green Lentils',1, 32, 3)
					, ('Peanuts Salted',1, 32, 3)
					, ('Peanuts Unsalted',1, 32, 3)
					, ('Cashew Nuts Salted',1, 32, 3)
					, ('Cashew Nuts Unsalted',1, 32, 3)
					, ('Pistachio Nuts',1, 32, 3)

					--Biscuits
					, ('Arnotts Farmbake Cookies',1, 33, 3)
					, ('Arnotts Tim Tams', 1, 33, 3)
					, ('Biscuits',1, 33, 3)
					, ('Anzac Biscuits',1, 33, 3)

					--Tissue
					, ('Paper Towels',1, 34, 3)

					--Milks
					, ('Rice Milk',1, 35, 3)
					, ('Almond Milk',1, 35, 3)

					--!KITCHEN CLEANERS
					, ('Dish Washing Liquid',1, 28, 4)
					, ('Oven Cleaner',1, 28, 4)
					, ('Bam Degreaser',1, 28, 4)
					, ('Drain Cleaner',1, 28, 4)
					, ('Cerapol Ceramic Cleaner',1, 28, 4)
					, ('Dish Washer Powder',1, 28, 4)
					, ('Dish Washer Rinse Aid',1, 28, 4)
					, ('Blue Dish Cloths',1, 28, 4)
					, ('Green Scouring Pads',1, 28, 4)
					, ('Stainless Steel Scourer',1, 28, 4)
					, ('Dish Washing Brush',1, 28, 4)

					--!LOUNGE
					, ('Bananas', 1, 31, 5)

					--!LAUNDRY
					, ('Ajax Floor Cleaner', 1, 28, 6)
					, ('Tissues',1, 34, 6)
					, ('Toilet Paper Rolls',1, 34, 6)
					, ('Palmolive Hair Shampoo',1, 25, 6)
					, ('Underarm Spray',1, 24, 6)
					, ('Shower Body Wash',1, 24, 6)
					, ('Hand Soap',1, 24, 6)
					, ('Toothpaste',1, 23, 6)
					, ('Washing Machine Powder',1, 30, 6)
					, ('Rubbish Bags',1, 30, 6)
					, ('Fly Spray',1, 30, 6)
					, ('Toilet Cleaner',1, 28, 6)
					, ('Bathroom Cleaner',1, 28, 6)
					, ('Shower Cleaner',1, 28, 6)
					, ('Mould Cleaner',1, 28, 6)
					, ('Chux Sponge',1, 30, 6)
					, ('John Hair Dye',1, 25, 6)

					--!BATHROOM
					, ('Underarm Ball',1, 24, 7)
					, ('Listerine',1, 23, 7)
					, ('Toothbrush Electric',1, 23, 7)
					, ('Toothbrush Manual',1, 23, 7)
					, ('Razor Blades',1, 26, 7)
					, ('Shaving Cream',1, 26, 7)
					, ('Lynx Body Wash',1, 24, 7)
					, ('Manju Hair Shampoo',1, 25, 7)
					, ('Manju Hair Conditioner',1, 25, 7)
					, ('Manju Hair Dye',1, 25, 7)

					--!BEDROOM
					, ('AT Hop Card',1, 38, 9)
					, ('Lotto',1, 38, 9)

			) AS Source 
			(
				  [Name]
				, [IsShipped]
				, [CategoryId]
				, [AreaId]
			)
	WHERE	[Name] = ISNULL(@Name,[Name])
)