CREATE VIEW [ADAPT].[vw_Journal_Entries_Delta2]
AS SELECT [Journal_ID], [AddDate], [AddUser], [BusinessObject], [Notes], [EntityID_1], [UPDATEDDATE], [ValidFrom], [ValidTo], [row_sha2], CAST(1 AS BIT) AS IsCurrent FROM DELTA.ADAPT_vw_Journal_Entries_Delta2;
GO