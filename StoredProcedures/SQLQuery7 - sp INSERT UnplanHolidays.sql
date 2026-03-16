--SQLQuery7 - sp INSERT UnplanHolidays.sql 
USE PV_521_Import;
SET DATEFIRST 1;
GO

CREATE OR ALTER PROCEDURE sp_UnplanHolidays 
	@group_name		AS		NCHAR(10),
	@hol_start		AS	DATE
AS
BEGIN
DECLARE @group_id	AS	INT		=	(SELECT group_id	FROM Groups		WHERE group_name = @group_name);
IF @group_id IS NULL OR @hol_start IS NULL RETURN;
IF OBJECT_ID('GroupUnplanHolidays', 'U') IS NOT NULL
   DROP TABLE dbo.GroupUnplanHolidays;
CREATE TABLE GroupUnplanHolidays (group_id INT NOT NULL,
								  [date] DATE NOT NULL,
								  PRIMARY KEY (group_id, [date]));
	DECLARE @hol_end		AS	DATE = DATEADD(DAY, 6, @hol_start);

	WHILE @hol_start <= @hol_end
	BEGIN
		INSERT	GroupUnplanHolidays(group_id, [date])
		VALUES	(@group_id, @hol_start);
		SET @hol_start = DATEADD(DAY, 1, @hol_start);
	END
END

--CREATE OR ALTER PROCEDURE sp_ÑancelUnplanHolidays 
--	@group_id	AS	INT,
--	@hol_start	AS	DATE
--AS
--BEGIN
--	DECLARE @hol_end	AS	DATE = DATEADD(DAY, 6, @hol_start);

--	DELETE FROM DaysOFF
--	WHERE [date] BETWEEN @hol_start AND @hol_end AND holiday = 99;
--END



