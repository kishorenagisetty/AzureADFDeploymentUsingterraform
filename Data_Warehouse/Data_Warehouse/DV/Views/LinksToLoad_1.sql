CREATE VIEW [DV].[LinksToLoad] AS SELECT O.ObjectMappingID, SourceSchema AS SchemaName, SourceTable AS ObjectName

FROM ELT.DVObjectMapping O
	WHERE DestinationTable LIKE 'LINK[_]%' and IsEnabled = 1;