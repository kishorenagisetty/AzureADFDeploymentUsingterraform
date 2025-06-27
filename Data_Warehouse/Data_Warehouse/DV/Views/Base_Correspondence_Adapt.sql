CREATE VIEW DV.Base_Correspondence_Adapt AS
(
SELECT
CONVERT(CHAR(66),C.CorrespondenceHash,1) AS CorrespondenceHash
,C.RecordSource
,R_CO.Description AS CorrespondenceOutcome
,R_MO.Description AS CorrespondenceMethod
,R_TP.Description AS CorrespondenceType
,C.CorrespondenceNotes
FROM DV.SAT_Correspondence_Adapt_Core C
LEFT JOIN DV.Dimension_References R_CO ON R_CO.Code = C.CorrespondenceOutcome AND R_CO.Category = 'CODE' AND R_CO.ReferenceSource = 'ADAPT.MD_MULTI_NAMES'
LEFT JOIN DV.Dimension_References R_MO ON R_MO.Code = C.CorrespondenceMethod AND R_MO.Category = 'CODE' AND R_MO.ReferenceSource = 'ADAPT.MD_MULTI_NAMES'
LEFT JOIN DV.Dimension_References R_TP ON R_TP.Code = C.CorrespondenceType AND R_TP.Category = 'CODE' AND R_TP.ReferenceSource = 'ADAPT.MD_MULTI_NAMES'
WHERE 
C.IsCurrent = 1
)