--SQLQueryHW- DIRECTIONS GROUPS STUDENTS.sql
USE PV_521_Import

--SELECT
--         direction_name AS [Направление]
--        , (
--             SELECT COUNT(DISTINCT group_id)
--             FROM Groups
--             WHERE direction = direction_id
--          ) AS [Количество групп]
--        , (
--             SELECT COUNT(stud_id)
--             FROM Students 
--             WHERE [group] IN (
--             SELECT group_id
--             FROM Groups
--             WHERE direction = direction_id
--          )
--          ) AS [Количество студентов]
--FROM
--          Directions 
--ORDER BY
--        [Направление]
--;

SELECT
          direction_name             AS      [Направление]
        , COUNT(DISTINCT group_id)   AS      [Количество групп]
        , COUNT(stud_id)             AS      [Количество студентов]
FROM
          Directions, Groups, Students 
WHERE     
          direction = direction_id
AND       [group] = group_id
GROUP BY
        direction_id, direction_name
ORDER BY
        [Направление]
;