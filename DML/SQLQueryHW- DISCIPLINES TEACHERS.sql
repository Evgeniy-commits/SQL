--SQLQueryHW- DISCIPLINES TEACHERS.sql

USE PV_521_Import;

SELECT
          discipline_name AS [Дисциплина]
        , COUNT(teacher) AS [Количество преподавателей]
FROM
        Disciplines, TeachersDisciplinesRelation 
WHERE   discipline = discipline_id

GROUP BY
        discipline_name

ORDER BY
        [Дисциплина]
;

