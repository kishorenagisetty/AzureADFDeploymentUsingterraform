CREATE VIEW [DV].[HubsToLoad] AS SELECT O.ObjectMappingID, SourceSchema AS SchemaName, SourceTable AS ObjectName
FROM ELT.DVObjectMapping O
WHERE DestinationTable LIKE 'HUB[_]%' and IsEnabled = 1;