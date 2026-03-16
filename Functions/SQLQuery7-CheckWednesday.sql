USE PV_521_Import;
SET DATEFIRST 1;
GO

CREATE OR ALTER FUNCTION CheckWednesday(
	@group_id			AS	INT,
	@cur_date			AS	DATE,
	@discipline_name	AS	NVARCHAR(150),
	@teacher_id			AS	SMALLINT
) RETURNS BIT
AS
BEGIN
	DECLARE @prev_wed	AS	DATE;-- = DATEADD(DAY, -7,	@cur_date);
	DECLARE @has_les	AS	BIT	 = 0;
	DECLARE @discipline	AS	SMALLINT =	(SELECT discipline_id FROM Disciplines WHERE discipline_name LIKE @discipline_name);
	 SET @prev_wed = @cur_date;

    WHILE DATEPART(WEEKDAY, @prev_wed) != 3 OR @prev_wed >= @cur_date
    BEGIN
        SET @prev_wed = DATEADD(DAY, -1, @prev_wed);
        -- Защита от бесконечного цикла
        IF @prev_wed < DATEADD(DAY, -365, @cur_date) -- не ищем дальше года назад
            BREAK;
    END
	IF @discipline	IS NOT NULL
	BEGIN
		IF EXISTS (SELECT 1 FROM Schedule WHERE [date] = @prev_wed AND [group] = @group_id AND discipline = @discipline)
			SET @has_les = 1;
	END
	IF @has_les = 0
	BEGIN
		IF EXISTS (SELECT 1 FROM Schedule WHERE [date] = @prev_wed AND [group] = @group_id AND teacher = @teacher_id)
			SET @has_les = 1;
	END
	RETURN @has_les;
END