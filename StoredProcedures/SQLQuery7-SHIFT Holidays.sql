--SQLQuery7-SHIFT Holidays.sql

USE PV_521_Import;
SET DATEFIRST 1;
GO

CREATE OR ALTER PROCEDURE sp_ShiftHoliday 
		@group_name		AS	NCHAR(10),
		@hol_start		AS	DATE
AS
BEGIN
	DECLARE @group	AS	 INT = (SELECT group_id	FROM Groups	WHERE group_name = @group_name);
	IF @group IS NULL OR @hol_start IS NULL RETURN;
	DECLARE @hol_end			AS	DATE = DATEADD(DAY, 6, @hol_start);
	DECLARE @year				AS  INT  = YEAR(@hol_start);
	DECLARE @summer_start_date	AS	DATE = dbo.GetSummertimeSadness(@year);
	DECLARE @winter_start_date	AS	DATE = dbo.GetNewYearHolidaysStartDate(@year);
	DECLARE @holiday			AS  NVARCHAR(25);
	DECLARE	@holiday_id			AS	TINYINT;
	DECLARE @duration			AS	TINYINT;


DROP TABLE IF EXISTS HolidaySchedule;

CREATE TABLE HolidaySchedule (group_id INT NOT NULL,
							  [date] DATE NOT NULL,
							  PRIMARY KEY (group_id, [date]));
BEGIN
	IF DATEDIFF(DAY, @hol_end, @summer_start_date) >= 0 
		BEGIN
			SET @summer_start_date = DATEADD(DAY, 7, @summer_start_date);
			SET @holiday		   = N'Летние каникулы';
			SET	@holiday_id		   = (SELECT holiday_id	FROM Holidays WHERE	holiday_name LIKE @holiday);
			SET @duration		   = (SELECT duration	FROM Holidays WHERE holiday_id = @holiday_id) - 7;
		WHILE  @duration > 0
		BEGIN
			INSERT	HolidaySchedule(group_id, [date])
			VALUES	(@group, @summer_start_date);
			SET @summer_start_date = DATEADD(DAY, 1, @summer_start_date);
			SET @duration -= 1;
		END
		INSERT INTO HolidaySchedule (group_id, [date])
		SELECT @group AS group_id, [date] FROM DaysOFF WHERE holiday != @holiday_id; 
		END
	ELSE
	BEGIN
			SET @winter_start_date = DATEADD(DAY, 7, @winter_start_date);
			SET @holiday		   = N'Нов%';
			SET	@holiday_id		   = (SELECT holiday_id	FROM Holidays WHERE	holiday_name LIKE @holiday);
			SET @duration		   = (SELECT duration	FROM Holidays WHERE holiday_id = @holiday_id) - 7;
		WHILE  @duration > 0
		BEGIN
			INSERT	HolidaySchedule(group_id, [date])
			VALUES	(@group, @winter_start_date);
			SET @winter_start_date = DATEADD(DAY, 1, @winter_start_date);
			SET @duration -= 1;
		END
		INSERT INTO HolidaySchedule (group_id, [date])
		SELECT @group AS group_id, [date] FROM DaysOFF WHERE holiday != @holiday_id; 
	END
END
END