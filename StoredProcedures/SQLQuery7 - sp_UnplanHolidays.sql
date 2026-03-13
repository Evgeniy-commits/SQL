--SQLQuery7 - sp_UnplanHolidays.sql 
USE PV_521_Import;
SET DATEFIRST 1;
GO

CREATE OR ALTER PROCEDURE sp_UnplanHolidays 
	@group_id	AS	INT,
	@hol_start	AS	DATE
AS
BEGIN
	DECLARE @holiday_id		AS	TINYINT = 99;
	DECLARE @hol_end		AS	DATE = DATEADD(DAY, 6, @hol_start);

	WHILE @hol_start <= @hol_end
	BEGIN
		INSERT	DaysOFF	([date], holiday)
		VALUES	(@hol_start, @holiday_id);
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



