CREATE VIEW [ADAPT].[SAT_References_MDMultiNames]
AS SELECT 
CONCAT_WS('|','MD_MULTI_NAMES',TYPE,ID) AS ReferenceKey,
ID AS [ID],
TYPE AS [Type],
LANGUAGE AS [Language],
NAME AS [Name],
DESCRIPTION AS [Description],
ValidFrom, ValidTo, IsCurrent
FROM ADAPT.MD_MULTI_NAMES;