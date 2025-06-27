CREATE VIEW DV.Dimension_Correspondence AS SELECT
CorrespondenceHash
,RecordSource
,CorrespondenceOutcome
,CorrespondenceMethod
,CorrespondenceType
,CorrespondenceNotes
FROM 
(
SELECT
CorrespondenceHash
,ROW_NUMBER() OVER (PARTITION BY [CorrespondenceHash] ORDER BY [CorrespondenceHash]) rn
,RecordSource
,CorrespondenceOutcome
,CorrespondenceMethod
,CorrespondenceType
,CorrespondenceNotes
FROM DV.Base_Correspondence
) src
WHERE (rn = 1);
GO
