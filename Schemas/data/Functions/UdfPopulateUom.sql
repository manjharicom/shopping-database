CREATE FUNCTION [data].[UdfPopulateUom]
(
	@Name NVARCHAR(50)
)
RETURNS TABLE AS RETURN
(
	SELECT
			  [Name]
	FROM	(
				VALUES
                   ('Bag') 
                 , ('Bunch') 
                 , ('Bin') 
                 , ('Block') 
                 , ('Bundle') 
                 , ('Bottle') 
                 , ('Box') 
                 , ('Can') 
                 , ('Chip') 
                 , ('Crate') 
                 , ('Carton') 
                 , ('Dozen') 
                 , ('Drum') 
                 , ('Each') 
                 , ('Jar') 
                 , ('Keg') 
                 , ('Kilo') 
                 , ('Pouch') 
                 , ('Packet') 
                 , ('Pottle') 
                 , ('Pair') 
                 , ('Ream') 
                 , ('Roll') 
                 , ('Shipper') 
                 , ('Sleeve') 
                 , ('Spray Bottle') 
                 , ('Tube') 
                 , ('Tin') 
                 , ('Tray') 
                 , ('Tub')
            ) AS Source 
			(
				  [Name]
			)
	WHERE	[Name] = ISNULL(@Name,[Name])
)