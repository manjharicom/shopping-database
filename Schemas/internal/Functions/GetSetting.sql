CREATE FUNCTION [internal].[GetSetting]
(
	@Name	NVARCHAR(50)
)
RETURNS NVARCHAR(500)
AS
BEGIN
	RETURN
		(
			SELECT
						s.[Value] 
				FROM	[dbo].[Settings] s
				WHERE	s.[Name] = @Name
		)
END
