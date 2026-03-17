--SQLQuery1-GetNextLearningDate.sql
USE PV_521_Import;
SET DATEFIRST 1;
GO

CREATE OR ALTER FUNCTION GetNextLearningDate (
		@group_name		AS	 NCHAR(10), 
		@date			AS	 DATE = N'1900-01-01', 
		@teacher		AS	 SMALLINT) RETURNS DATE
AS
BEGIN
	DECLARE @group_id		AS	INT		    =	(SELECT group_id	 FROM Groups	WHERE group_name = @group_name);
	IF @date = CAST(N'1900-01-01' AS DATE)
			SET @date				    =	(SELECT MAX([date])  FROM Schedule	WHERE [group] = @group_id);
	--DECLARE @teacher		AS	SMALLINT    =   (SELECT teacher_id FROM Teachers	WHERE last_name LIKE @teacher_name);
	DECLARE @day			AS	SMALLINT	=	DATEPART(WEEKDAY, @date);
	DECLARE @next_day		AS	SMALLINT	=	dbo.GetNextLearningDay(@group_name, @date);
	DECLARE @interval		AS	SMALLINT	=	@next_day - @day;
	IF(@interval < 0)	SET @interval = 7 + @interval;
	IF(@interval = 0)	SET @interval = 7;
	DECLARE @next_date		AS	DATE	=	DATEADD(DAY, @interval, @date);
	DECLARE @teacher_free	AS BIT  =	1;

	IF EXISTS (SELECT 1 FROM Schedule WHERE [date] = @next_date AND teacher = @teacher AND [group] != @group_id)
		SET @teacher_free = 0;
	RETURN
	IIF (@teacher_free = 1
		AND (NOT EXISTS (SELECT 1 FROM HolidaySchedule WHERE group_id = @group_id AND [date] = @next_date))
		AND (NOT EXISTS (SELECT 1 FROM GroupUnplanHolidays WHERE  group_id = @group_id AND [date] = @next_date)),
		@next_date, dbo.GetNextLearningDate(@group_name, @next_date, @teacher));
	--IF NOT EXISTS (SELECT 1 FROM DaysOFF WHERE [date] = @next_date) 
	--   AND NOT EXISTS (SELECT 1 FROM GroupUnplanHolidays WHERE  group_id = @group_id AND [date] = @next_date)
	--   SET @next_date = dbo.GetNextLearningDate(@group_name, @next_date);
	--RETURN @next_date;
END