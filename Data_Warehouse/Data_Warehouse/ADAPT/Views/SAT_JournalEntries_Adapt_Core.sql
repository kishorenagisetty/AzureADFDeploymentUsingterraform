CREATE VIEW [ADAPT].[SAT_JournalEntries_Adapt_Core] AS Select  
		CONCAT_WS('|', 'ADAPT', CAST(JE.Journal_ID AS INT))		AS JournalEntriesKey,
		CONCAT_WS('|', 'ADAPT', CAST(JE.ENTITYID_1 AS BIGINT))	AS JournalEntriesEntityIDKey,		
		AddDate													AS AddDate,
		AddUser													AS Addedby,
		BusinessObject											As BusinessObject,
		Notes													AS JournalNotes,
		UPDATEDDATE												AS NotesEditDate,
		JE.ValidFrom,
		JE.ValidTo,
		JE.IsCurrent

FROM	[ADAPT].[vw_Journal_Entries_Delta2] JE;
GO
