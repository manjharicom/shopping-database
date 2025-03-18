CREATE FUNCTION [internal].[GetPopulateSetting]
(
)
RETURNS DATETIME2
AS
BEGIN
	RETURN
		(
			SELECT CONVERT(DATETIME2,[internal].[GetSetting](N'Populate'))
		)
END
