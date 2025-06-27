CREATE VIEW [dwh].[Fact_JournalEntries]
AS 
-- Author: Mohmed Kapadia
-- Modified date: 05/07/2023
-- Ticket Reference:  <25021>
-- Description: <Jornal Entries Fact DWH View>
-- Revisions: 2
-- 05/07/2023 - <MK> - <25021> - <Link table changed from [DV].[LINK_Participant_JournalEntries] to [DV].[LINK_Case_JournalEntries] and added additional columns : AddedBy, BusinessObject  >

Select	CJE.JournalEntriesHash															As JournalEntriesHashBin
		,convert(char(66),isnull(CJE.JournalEntriesHash	,cast(0x0 as binary(32))),1)	As JournalEntriesHash
		,CJE.CaseHash																	As CaseHashBin
		,convert(char(66),isnull(CJE.CaseHash,cast(0x0 as binary(32))),1)				As CaseHash
		,SJE.AddDate
		,SJE.AddedBy
		,SJE.BusinessObject
		,SJE.JournalNotes
		,SJE.NotesEditDate

From [DV].[LINK_Case_JournalEntries] CJE -- 05/07/2023 <MK> <25021>
Inner Join [DV].[SAT_JournalEntries_Adapt_Core] SJE 
On CJE.JournalEntriesHash = SJE.JournalEntriesHash And SJE.IsCurrent = 1;
GO