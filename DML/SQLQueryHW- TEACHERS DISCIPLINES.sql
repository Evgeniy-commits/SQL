--SQLQueryHW- TEACHERS DISCIPLINES.sql

USE PV_521_Import;

SELECT
     FORMATMESSAGE(N'%s %s %s', last_name,first_name,middle_name) AS [Преподаватель]
    , birth_date AS [Дата рождения]
    , DATEDIFF(YEAR, birth_date, GETDATE())                       AS [Возраст]
    , COUNT(discipline)                                           AS [количество дисциплин]
FROM 
    Teachers, TeachersDisciplinesRelation
WHERE teacher = teacher_id
GROUP BY
    teacher_id,
    last_name,
    first_name,
    middle_name,
    birth_date
ORDER BY
    [Преподаватель];