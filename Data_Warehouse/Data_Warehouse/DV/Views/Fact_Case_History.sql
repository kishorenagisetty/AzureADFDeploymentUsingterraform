CREATE VIEW [DV].[Fact_Case_History]

AS 

WITH
    CaseStartDate AS (
        SELECT
             C.CaseHash
            ,C.CaseKey
            ,CASE WHEN S_AD.StartDate IS NULL THEN -1 ELSE CAST(CONVERT(CHAR(8),S_AD.StartDate,112) AS INT) END AS StartDateKey
        FROM DV.HUB_Case C
        INNER JOIN DV.SAT_Case_Adapt_Dates S_AD ON S_AD.CaseHash = C.CaseHash AND S_AD.IsCurrent = 1
        AND S_AD.StartDate > DATEADD(month, -37, getdate ())
        AND S_AD.StartDate IS NOT NULL
    ),
    CaseStartDateAndSnapshotDate AS (
        SELECT
             CaseHash
            ,CaseKey
            ,StartDateKey
            ,D.Date_Key AS SnapshotDateKey
            ,DATEADD(ss, -1, DATEADD(day, 1, (Cast (D.Date as DateTime))))  As SnapshotDate
        FROM CaseStartDate
        CROSS JOIN [DV].[Dimension_Date] D
        WHERE D.Date_Key BETWEEN StartDateKey AND FORMAT(GETDATE(), 'yyyyMMdd')
        AND D.Date > DATEADD(month, -24, getdate ())
        AND D.[Day_Of_Month] = 1
    ),
    CaseWithDatesAndReadiness AS (
        SELECT        
             CWD.CaseHash
            ,CWD.CaseKey
            ,CWD.StartDateKey
            ,CWD.SnapshotDateKey
            ,CASE WHEN C.WorkRedinessStatus IS NULL THEN -1 ELSE C.WorkRedinessStatus END AS WorkReadinessStatus
        FROM CaseStartDateAndSnapshotDate CWD
         LEFT JOIN [DV].[SAT_Case_Adapt_Core] C ON
             CWD.CaseHash = C.CaseHash AND CWD.SnapshotDate BETWEEN C.ValidFrom  AND C.ValidTo
    )
    ,FactWorkReadiness AS (
    SELECT
         CONVERT(CHAR(66), CaseHash, 1) CaseHash
        ,StartDateKey
        ,SnapshotDateKey
        ,Casekey
        ,WorkReadinessStatusHash = 
			CASE WHEN WorkReadinessStatus = -1 THEN CONVERT(CHAR(66),CAST(0x0 AS BINARY(32)),1) 
				 ELSE CONVERT(CHAR(66),CAST(HASHBYTES('SHA2_256',CAST(CAST(WorkReadinessStatus AS BIGINT) AS VARCHAR)) AS BINARY(32)),1)
			END
    FROM CaseWithDatesAndReadiness
    )
SELECT * FROM FactWorkReadiness;
GO
