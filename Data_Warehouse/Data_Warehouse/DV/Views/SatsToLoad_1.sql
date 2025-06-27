CREATE VIEW [DV].[SatsToLoad] AS SELECT O.ObjectMappingID, SourceSchema AS SchemaName, SourceTable AS ObjectName

FROM ELT.DVObjectMapping O

WHERE DestinationTable LIKE 'SAT[_]%' and IsEnabled = 1;