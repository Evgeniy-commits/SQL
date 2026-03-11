--SQLQuery0-Check.sql
USE PV_521_Import;
SET DATEFIRST 1;

---DELETE FROM Schedule WHERE discipline = (SELECT discipline_id FROM Disciplines WHERE discipline_name LIKE N'%ADO.NET%');
EXEC sp_InsertScheduleStacionar N'PV_521', N'%ADO.NET%', N'Юыху', N'2026-01-21';
EXEC sp_SelectScheduleFor N'PV_521';
