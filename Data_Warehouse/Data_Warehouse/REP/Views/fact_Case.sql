CREATE VIEW REP.fact_Case
AS
-- ===============================================================
-- Author:	Sagar Kadiyala
-- Create date: 31/01/2024
-- Ticket Ref: #30330
-- Name: REP.fact_Case  
-- Description: Fact Table
-- Revisions:
-- 30330 - SK - 01/02/2024 - Created a Fact View for cases
-- 33770 - SK - 21/03/2024 - Added 2 columns in the Fact View for dates
-- ===============================================================
SELECT hc.recordSource
     , CONVERT(char(66), hc.CaseHash, 1)										AS CaseHash
     , REPLACE(CAST(hc.CaseKey AS VARCHAR(25)), 'ICONI|', '')					AS CaseKey
     , CONVERT(char(66),isnull(lce.employeeHash,cast(0x0 as binary(32))),1)     AS EmployeeHash
     , CONVERT(char(66),isnull(lcd.DeliverySiteHash,cast(0x0 as binary(32))),1)	AS DeliverySiteHash
     , CONVERT(char(66),isnull(lrp.ProgrammeHash,cast(0x0 as binary(32))),1)	AS ProgrammeHash
     , CONVERT(char(66),isnull(lcp.ParticipantHash,cast(0x0 as binary(32))),1)	AS ParticipantHash
     , CAST(scdr.startDate AS DATE)												AS StartDate
     , CAST(scdr.LeaveDate AS DATE)												AS ExitDate
     , CAST(scdr.LeftDate AS DATE)												AS LeftDate
     , CAST(scdr.ReferralDate AS DATE)											AS ReferralDate
     , CAST(scdr.DidNotStartDate AS DATE)										AS DidNotStartDate
     , CAST(scdr.TransactionAddedDate AS DATE)									AS AddedDate
     , CAST(scdr.WelcomePackIssueDate AS DATE)									AS WelcomePackIssueDate
FROM [DV].[HUB_Case]                         hc
    JOIN [DV].[SAT_Case_Iconi_Refugee]       scir
        ON hc.[CaseHash] = scir.[CaseHash] AND scir.iscurrent = 1
    JOIN [DV].[SAT_Case_Iconi_Dates_Refugee] scdr
        ON hc.[CaseHash] = scdr.[CaseHash] AND scdr.iscurrent = 1
    LEFT JOIN [DV].[LINK_Case_Employee]      lce
        ON hc.caseHash = lce.caseHash
    LEFT JOIN DV.LINK_Case_DeliverySite      lcd
        ON hc.caseHash = lcd.caseHash
    LEFT JOIN [DV].[LINK_Referral_Programme] lrp
        ON hc.caseHash = lrp.ReferralHash
    LEFT JOIN [DV].[LINK_Case_Participant]   lcp
        ON hc.caseHash = lcp.caseHash;

Go