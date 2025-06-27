-- This is for testing by Sarath Koritala
CREATE VIEW [ADAPT].[HUB_JournalEntries] AS 
SELECT
CONCAT_WS('|', 'ADAPT', CAST(Journal_ID AS INT))	AS JournalEntriesKey,
'ADAPT.vw_Journal_Entries_Delta2'					AS RecordSource,
ValidFrom,
ValidTo,
IsCurrent

FROM	[ADAPT].[vw_Journal_Entries_Delta2];
GO