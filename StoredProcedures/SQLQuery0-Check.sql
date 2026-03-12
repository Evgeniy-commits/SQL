--SQLQuery0-Check.sql
USE PV_521_Import;
SET DATEFIRST 1;

--DELETE FROM Schedule WHERE [group] = 521;
--DELETE FROM Schedule WHERE discipline = (SELECT discipline_id FROM Disciplines WHERE discipline_name LIKE N'Сетевое%');
--EXEC sp_InsertScheduleStacionar N'PV_521', N'%ADO.NET%', N'Олег', N'2026-01-21';
--EXEC sp_InsertSchedule1221 N'PV_521', N'Hardware%', N'Свищев', N'2025-01-20', 1, 3, 5;
--EXEC sp_InsertSchedule1221 N'PV_521', N'%Windows', N'Свищев', N'2025-04-30', 1, 3, 5;
--EXEC sp_InsertSchedule1221 N'PV_521', N'Процедурное%C++', N'Ковтун', N'2025-01-20', 5, 3, 1;
--EXEC sp_InsertAllHolidaysFor 2027;
--EXEC sp_SelectScheduleFor N'PV_521';

SELECT
	[Дата]		=	date,
	[Праздник]	=	holiday_name
FROM	DaysOFF, Holidays
WHERE	holiday = holiday_id 
AND		date >= DATEFROMPARTS(2025,12,20);