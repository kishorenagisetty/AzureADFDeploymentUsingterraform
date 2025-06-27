CREATE VIEW [ICONI].[LINK_Case_Employee] 
-- ===============================================================
-- Author:	Sagar Kadiyala
-- Create date: 31/01/2024
-- Ticket Ref: #30330
-- Name: [REP].[dim_deliverySite] 
-- Description: Dimension Table
-- Revisions:
-- 30330 - SK - 31/01/2024 - Created a Dimension View for delivery Sites
-- ===============================================================
AS
SELECT CONCAT_WS('|', 'ICONI', C.engagement_id) AS CaseKey
     , CONCAT_WS('|', 'ICONI', E.[user_id])     AS EmployeeKey
     , 'ICONI.User_Restart'                     AS RecordSource
     , E.ValidFrom
     , E.ValidTo
     , E.IsCurrent
FROM [ICONI].[vBICommon_User]                  AS E
    INNER JOIN [ICONI].[vBIRestart_Engagement] AS C
        ON E.[user_id] = C.eng_tran_owner_user_id
           AND E.IsCurrent = 1
           AND C.IsCurrent = 1
UNION
SELECT CONCAT_WS('|', 'ICONI', C.engagement_id) AS CaseKey
     , CONCAT_WS('|', 'ICONI', E.[user_id])     AS EmployeeKey
     , 'ICONI.User_Refugee'                     AS RecordSource
     , E.ValidFrom
     , E.ValidTo
     , E.IsCurrent
FROM [ICONI].[vBICommon_User]                  AS E
    INNER JOIN [ICONI].[vBIRefugee_Engagement] AS C
        ON E.[user_id] = C.eng_tran_owner_user_id
           AND E.IsCurrent = 1
           AND C.IsCurrent = 1
GO