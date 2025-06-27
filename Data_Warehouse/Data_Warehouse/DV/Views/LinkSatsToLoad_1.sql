CREATE VIEW [DV].[LinkSatsToLoad]
AS SELECT O.ObjectMappingID, SourceSchema AS SchemaName, SourceTable AS ObjectName



FROM ELT.DVObjectMapping O



WHERE DestinationTable LIKE 'LINKSAT[_]%' and IsEnabled = 1;