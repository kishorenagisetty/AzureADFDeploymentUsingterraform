CREATE VIEW REP.fact_Activity
AS
-- ===============================================================
-- Author:	Sagar Kadiyala
-- Create date: 12/01/2024
-- Ticket Ref: #30330
-- Name: REP.fact_Activity 
-- Description: fact Activity
-- Revisions:
-- 30330 - SK - 05/02/2024 - Created a Fact View for Activities
-- ===============================================================
  SELECT  CONVERT(char(66), ha.ActivityHash, 1)									AS ActivityHash
		, REPLACE(CAST(sar.ActivityKey as varchar(25)), 'ICONI|', '')			AS ActivityKeyNumber
		, CONVERT(char(66),isnull(lca.caseHash,cast(0x0 as binary(32))),1)		AS CaseHash
		, CONVERT(char(66),isnull(lae.EmployeeHash,cast(0x0 as binary(32))),1)	AS EmployeeHash
		, CAST(sar.ActivityStartDate AS DATE)									AS ActivityStartDate
		, sar.ActivityType		 												AS ActivityType
		, sar.ActivityContactMethod												AS ActivityContactMethod
		, sar.ActivityStatus													AS ActivityStatus
		, CAST(sar.meet_added_date AS DATE)										AS MeetAddedDate
		, CAST(sar.ActivityCompletedDate AS DATE)								AS ActivityCompletedDate
  FROM [DV].[HUB_Activity] ha
  JOIN [DV].[SAT_Activity_Iconi_Refugee] sar
  ON ha.ActivityHash = sar.ActivityHash
  LEFT JOIN [DV].[LINK_Case_Activity] lca
  ON ha.ActivityHash = lca.[ActivityHash]
  LEFT JOIN [DV].[LINK_Activity_Employee] lae
  ON ha.ActivityHash = lae.ActivityHash
  WHERE sar.ActivityLevel = 'Individual'
  AND sar.IsCurrent = 1;
  Go

  