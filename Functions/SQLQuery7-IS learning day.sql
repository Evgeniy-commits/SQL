--SQLQuery7-IS learning day.sql

USE PV_521_Import;
SET DATEFIRST 1;
GO

CREATE OR ALTER FUNCTION IsLearningDay (@date AS DATE, @group AS INT) RETURNS BIT
AS
BEGIN
	IF EXISTS (SELECT 1 FROM DaysOFF WHERE [date] = @date AND holiday = 99)
		RETURN 0;
	IF EXISTS (SELECT 1 FROM DaysOFF WHERE [date] = @date AND holiday != 99)
		RETURN 0;
	RETURN 1;
END