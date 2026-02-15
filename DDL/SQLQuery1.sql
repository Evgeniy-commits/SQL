USE PV_521_DDL;

SELECT 
    o.name AS ObjectName,
    s.name AS SchemaName,
    o.type_desc AS ObjectType
FROM sys.objects o
JOIN sys.schemas s ON o.schema_id = s.schema_id
WHERE o.name = 'Directions';