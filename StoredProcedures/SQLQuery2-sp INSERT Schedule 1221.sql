--SQLQuery2-sp INSERT Schedule 1221.sql
USE PV_521_Import;
SET DATEFIRST 1;
GO

--CREATE OR ALTER PROCEDURE sp_InsertSchedule1221
--	@group_name				AS   NCHAR(10),
--	@discipline_1_name		AS	 NVARCHAR(150),
--	@discipline_2_name		AS	 NVARCHAR(150),
--	@constant_1_day			AS	 TINYINT,
--	@constant_2_day			AS	 TINYINT,
--	@alternate_day			AS	 TINYINT
--AS
--BEGIN
--	DECLARE @group_id		AS	INT		 =	(SELECT group_id	  FROM Groups	   WHERE group_name = @group_name);
--	DECLARE @discipline_1	AS	SMALLINT =	(SELECT discipline_id FROM Disciplines WHERE discipline_name = @discipline_1_name);
--	DECLARE @discipline_2	AS	SMALLINT =	(SELECT discipline_id FROM Disciplines WHERE discipline_name = @discipline_2_name);
--	DECLARE @number_of_lessons_1	AS	TINYINT = (SELECT number_of_lessons FROM Disciplines WHERE discipline_id = @discipline_1_name);
--	DECLARE @number_of_lessons_2	AS	TINYINT = (SELECT number_of_lessons FROM Disciplines WHERE discipline_id = @discipline_2_name);
--END

CREATE OR ALTER PROCEDURE sp_InsertSchedule1221
	@group_name			AS		NCHAR(10),
	@discipline_name	AS		NVARCHAR(150),
	@teacher_name		AS		NVARCHAR(50),
	@start_date			AS		DATE,
	@constant_day		AS		TINYINT,
	@alternate_day		AS		TINYINT,
	--@denied_day			AS		TINYINT,
	@first_week_present AS		BIT
AS
BEGIN
	DECLARE @group				AS	 INT      =	(SELECT group_id			FROM Groups		 WHERE group_name = @group_name);
	DECLARE @discipline			AS	 SMALLINT =	(SELECT discipline_id		FROM Disciplines WHERE discipline_name LIKE @discipline_name);
	DECLARE @number_of_lessons	AS	 TINYINT  =	(SELECT number_of_lessons	FROM Disciplines WHERE discipline_name LIKE @discipline_name);
	DECLARE @lessons_number		AS	 TINYINT  = (SELECT COUNT(lesson_id) FROM Schedule WHERE discipline = @discipline AND [group] = @group);
	DECLARE @teacher			AS	 SMALLINT =	(SELECT teacher_id FROM Teachers WHERE last_name LIKE @teacher_name OR first_name LIKE @teacher_name);
	--DECLARE @start_date			AS	 DATE     =	(SELECT MAX([date]) FROM Schedule WHERE [group] = @group);
	IF @start_date IS NULL SET @start_date    = (SELECT [start_date] FROM Groups WHERE group_id = @group);
	DECLARE @start_time			AS	 TIME	  = (SELECT start_time FROM Groups WHERE group_id = @group);
	DECLARE @date				AS	 DATE	  = @start_date;
	DECLARE @time				AS	 TIME	  = @start_time;

	DECLARE @previous_week_present	AS	 BIT	  = IIF(@first_week_present = 1, 0, 1);

	WHILE @lessons_number < @number_of_lessons
	BEGIN
		SET @time = @start_time;
		IF DATEPART(WEEKDAY, @date) = @constant_day OR (DATEPART(WEEKDAY, @date) = @alternate_day AND @previous_week_present = 0)
		BEGIN
			EXEC sp_InsertLesson @group, @discipline, @teacher, @date, @time OUTPUT, @lessons_number OUTPUT;
			EXEC sp_InsertLesson @group, @discipline, @teacher, @date, @time OUTPUT, @lessons_number OUTPUT;
		END
		--IF DATEPART(WEEKDAY, @date) = @denied_day
		--	SET @date = dbo.GetNextLearningDate(@group_name, @date);
		IF DATEPART(WEEKDAY, @date) = @alternate_day
			SET @previous_week_present = IIF(@previous_week_present = 1, 0, 1);
			
		SET @date = dbo.GetNextLearningDate(@group_name, @date);
	END
END



--CREATE OR ALTER PROCEDURE sp_InsertSchedule1221
--	@group_name			AS		NCHAR(10),
--	@discipline_name	AS		NVARCHAR(150),
--	@teacher_name		AS		NVARCHAR(50),
--	@start_date			AS		DATE,
--	@constant_day		AS		TINYINT,
--	@alternate_day		AS		TINYINT,
--	@denied_day			AS		TINYINT
--AS
--BEGIN
--	DECLARE @group				AS	 INT      =	(SELECT group_id			FROM Groups		 WHERE group_name = @group_name);
--	DECLARE @discipline			AS	 SMALLINT =	(SELECT discipline_id		FROM Disciplines WHERE discipline_name LIKE @discipline_name);
--	DECLARE @number_of_lessons	AS	 TINYINT  =	(SELECT number_of_lessons	FROM Disciplines WHERE discipline_name LIKE @discipline_name);
--	DECLARE @lessons_number		AS	 TINYINT  = (SELECT COUNT(lesson_id) FROM Schedule WHERE discipline = @discipline AND [group] = @group);
--	DECLARE @teacher			AS	 SMALLINT =	(SELECT teacher_id FROM Teachers WHERE last_name LIKE @teacher_name OR first_name LIKE @teacher_name);
--	--DECLARE @start_date			AS	 DATE     =	(SELECT MAX([date]) FROM Schedule WHERE [group] = @group);
--	IF @start_date IS NULL SET @start_date    = (SELECT [start_date] FROM Groups WHERE group_id = @group);
--	DECLARE @start_time			AS	 TIME	  = (SELECT start_time FROM Groups WHERE group_id = @group);
--	DECLARE @date				AS	 DATE	  = @start_date;
--	DECLARE @time				AS	 TIME	  = @start_time

--	WHILE @lessons_number < @number_of_lessons
--	BEGIN
--		SET @time = @start_time;
--		IF DATEPART(WEEKDAY, @date) = 3
--			BEGIN
--				DECLARE @has_les	AS	BIT = dbo.CheckWednesday(@group, @date, @discipline_name, @teacher);
--				IF @has_les = 0
--					BEGIN
--						EXEC sp_InsertLesson @group, @discipline, @teacher, @date, @time OUTPUT, @lessons_number OUTPUT;
--						EXEC sp_InsertLesson @group, @discipline, @teacher, @date, @time OUTPUT, @lessons_number OUTPUT;
--					END
--			END
--		ELSE
--		BEGIN
--			EXEC sp_InsertLesson @group, @discipline, @teacher, @date, @time OUTPUT, @lessons_number OUTPUT;
--			EXEC sp_InsertLesson @group, @discipline, @teacher, @date, @time OUTPUT, @lessons_number OUTPUT;
--		END
--		--IF DATEPART(WEEKDAY, @date) = @constant_day SET @date = DATEADD(DAY, 7, @date);
--		SET @date = dbo.GetNextLearningDate(@group_name, @date);
--		WHILE DATEPART(WEEKDAY, @date) = @denied_day
--		BEGIN
--			SET @date = dbo.GetNextLearningDate(@group_name, @date);
--			IF DATEPART(WEEKDAY, @date) = @alternate_day 
--			AND EXISTS (SELECT lesson_id FROM Schedule WHERE [date] = DATEADD(DAY, -7, @date)
--			AND discipline = @discipline)
--			SET @date = dbo.GetNextLearningDate(@group_name, @date);
--		END
--	END
--END