CREATE VIEW [DV].[Fact_AssignmentEarnings]
AS SELECT
CONVERT(CHAR(66),ISNULL(AA.AssignmentEarningPatternHash,CAST(0x0 AS BINARY(32))),1)	AS AssignmentEarningPatternHash,
CONVERT(CHAR(66),ISNULL(AA.AssignmentHash,CAST(0x0 AS BINARY(32))),1) AS AssignmentHash,
CONVERT(CHAR(66),ISNULL(AA.CaseHash,CAST(0x0 AS BINARY(32))),1)	AS CaseHash,
CONVERT(CHAR(66),ISNULL(AA.ParticipantHash, CAST(0x0 AS BINARY(32))) ,1) AS ParticipantHash,
CONVERT(CHAR(66),ISNULL(AA.EmployeeHash, CAST(0x0 AS BINARY(32))),1) AS EmployeeHash,
CONVERT(CHAR(66),ISNULL(AA.ReferralHash, CAST(0x0 AS BINARY(32))) ,1) AS ReferralHash,
CONVERT(CHAR(66),ISNULL(AA.ProgrammeHash, CAST(0x0 AS BINARY(32))),1) AS ProgrammeHash,
CONVERT(CHAR(66),ISNULL(AA.DeliverySiteHash, CAST(0x0 AS BINARY(32))),1) AS DeliverySiteHash,
AssignmentEarningPatternKey,
WorkingDayKey,
Working_Hours,
Hourly_Rate,
Weekly_Hours
FROM DV.F_AssignmentEarnings AA