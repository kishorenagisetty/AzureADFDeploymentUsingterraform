CREATE PROC [DV].[sp_ADAPT_F_AssignmentEarnings] AS 
IF object_id ('stg.DV_AssignmentEarningPattern_TEMP','U') is not null  drop table stg.DV_AssignmentEarningPattern_TEMP;
IF OBJECT_ID('stg.DV_AssignmentPatternLinks_TEMP','U')  IS NOT NULL DROP TABLE	stg.DV_AssignmentPatternLinks_TEMP;

CREATE TABLE stg.DV_AssignmentEarningPattern_TEMP
			 WITH (clustered columnstore index, distribution = hash(AssignmentEarningPatternHash))
AS

WITH cte_hrs_null AS
(
SELECT
hr.AssignmentEarningPatternHash
,hr.AssignmentEarningPatternKey
,hr.Reference
,hr.EffectFrom
,coalesce(hr.EffectTo, a.WorkTrialEndDate,a.AssignmentLeaveDate,sca.LeaveDate)  as EffectTo
,CASE WHEN hr.Monday IS NULL THEN '0.00' ELSE hr.Monday END AS 'Monday'
,CASE WHEN hr.Tuesday IS NULL THEN '0.00' ELSE hr.Tuesday END AS 'Tuesday'
,CASE WHEN hr.Wednesday IS NULL THEN '0.00' ELSE hr.Wednesday END AS 'Wednesday'
,CASE WHEN hr.Thursday IS NULL THEN '0.00' ELSE hr.Thursday END AS 'Thursday'
,CASE WHEN hr.Friday IS NULL THEN '0.00' ELSE hr.Friday END AS 'Friday'
,CASE WHEN hr.Saturday IS NULL THEN '0.00' ELSE hr.Saturday END AS 'Saturday'
,CASE WHEN hr.Sunday IS NULL THEN '0.00' ELSE hr.Sunday END AS 'Sunday'
,CASE WHEN hr.HourlyRate IS NULL THEN '0.00' ELSE hr.HourlyRate END AS 'HourlyRate'
,CASE WHEN hr.WeeklyHours IS NULL THEN '0.00' ELSE hr.WeeklyHours END AS  'WeeklyHours'
,md.DESCRIPTION AS 'Status'
FROM DV.SAT_AssignmentEarningPattern_Adapt_Core hr
INNER JOIN DV.Dimension_References md ON md.CODE = hr.STATUS
left outer join dv.link_Assignment_AssignmentEarningPattern as l on hr.AssignmentEarningPatternHash = l.AssignmentEarningPatternHash
left outer join dv.SAT_Assignment_Adapt_Core as a on l.AssignmentHash = a.AssignmentHash and hr.IsCurrent = a.IsCurrent
LEFT JOIN DV.LINK_Case_Assignment lca ON lca.AssignmentHash = a.AssignmentHash
LEFT JOIN DV.SAT_Case_Adapt_Dates sca ON sca.CaseHash = lca.CaseHash AND sca.IsCurrent = 1
where	hr.iscurrent = 1
AND a.AssignmentStartClaimYear NOT LIKE 'DNC%'
),cte_hrs AS 
(
SELECT
h.AssignmentEarningPatternHash 
,AssignmentEarningPatternKey
,CASE WHEN h.EffectFrom IS NULL THEN -1 ELSE CAST(CONVERT(CHAR(8),h.EffectFrom,112) AS INT) END AS 'Earning_From_Date'
,CASE WHEN h.EffectTo IS NULL THEN CAST(CONVERT(CHAR(8),DATEADD(YEAR,1,GETDATE()),112) AS INT) ELSE CAST(CONVERT(CHAR(8),h.EffectTo,112) AS INT) END AS 'Earning_To_Date'
,CASE WHEN h.Monday = '0.00' AND h.Tuesday = '0.00' AND h.Wednesday = '0.00' AND h.Thursday = '0.00' AND h.Friday = '0.00' AND h.Saturday = '0.00' AND h.Sunday = '0.00'  THEN 1 ELSE 0 END AS 'Hours_Split_Marker'
,h.Monday AS 'MON'
,h.Tuesday AS 'TUE'
,h.Wednesday AS 'WED'
,h.Thursday AS 'THU'
,h.Friday AS 'FRI'
,h.Saturday AS 'SAT'
,h.Sunday AS 'SUN'
,h.HourlyRate AS 'HOURLY_RATE'
,h.WeeklyHours AS 'WEEKLY_HRS'
,Status AS 'Status'
FROM	
cte_hrs_null h
WHERE 
Status <> 'Soft Deleted'
AND h.WeeklyHours <> '0.00'
),cte_hrs1 AS 
(
SELECT
AssignmentEarningPatternHash
,AssignmentEarningPatternKey
,h.Earning_From_Date
,h.Earning_To_Date
,CASE WHEN h.Hours_Split_Marker = 1 THEN h.WEEKLY_HRS / 5 ELSE h.MON END AS 'MON'
,CASE WHEN h.Hours_Split_Marker = 1 THEN h.WEEKLY_HRS / 5 ELSE h.TUE END AS 'TUE'
,CASE WHEN h.Hours_Split_Marker = 1 THEN h.WEEKLY_HRS / 5 ELSE h.WED END AS 'WED'
,CASE WHEN h.Hours_Split_Marker = 1 THEN h.WEEKLY_HRS / 5 ELSE h.THU END AS 'THU'
,CASE WHEN h.Hours_Split_Marker = 1 THEN h.WEEKLY_HRS / 5 ELSE h.FRI END AS 'FRI'
,CASE WHEN h.Hours_Split_Marker = 1 THEN h.WEEKLY_HRS / 5 ELSE h.SAT END AS 'SAT'
,CASE WHEN h.Hours_Split_Marker = 1 THEN h.WEEKLY_HRS / 5 ELSE h.SUN END AS 'SUN'
,h.HOURLY_RATE
,h.WEEKLY_HRS
,h.Status
FROM cte_hrs h
WHERE h.Status <> 'Soft Deleted'
),CTE_Test AS
(
SELECT 
AssignmentEarningPatternHash
,AssignmentEarningPatternKey
,h.Earning_From_Date
,h.Earning_To_Date
,h.MON
,CASE WHEN h.MON <> '0.00' THEN 'Mon' ELSE NULL END AS 'Mon_WorkingDay'
,h.TUE
,CASE WHEN h.TUE <> '0.00' THEN 'Tue' ELSE NULL END AS 'Tue_WorkingDay'
,h.WED
,CASE WHEN h.WED <> '0.00' THEN 'Wed' ELSE NULL END AS 'Wed_WorkingDay'
,h.THU
,CASE WHEN h.THU <> '0.00' THEN 'Thu' ELSE NULL END AS 'Thu_WorkingDay'
,h.FRI
,CASE WHEN h.FRI <> '0.00' THEN 'Fri' ELSE NULL END AS 'Fri_WorkingDay'
,h.SAT
,CASE WHEN h.SAT <> '0.00' THEN 'Sat' ELSE NULL END AS 'Sat_WorkingDay'
,h.SUN
,CASE WHEN h.SUN <> '0.00' THEN 'Sun' ELSE NULL END AS 'Sun_WorkingDay'
,h.HOURLY_RATE
,h.WEEKLY_HRS
,h.Status
FROM
cte_hrs1 h
),cte_dates_worked AS 
(
SELECT  
AssignmentEarningPatternHash
,AssignmentEarningPatternKey
,d.Date_Skey AS 'WorkingDayKey'
,Day_Name_Short
,CASE WHEN t.Mon_WorkingDay = Day_Name_Short THEN 1 ELSE 0 END AS 'Mon_WorkingDay'
,CASE WHEN t.Mon_WorkingDay = Day_Name_Short THEN MON END AS 'Mon_WorkingHours'
,CASE WHEN t.Tue_WorkingDay = Day_Name_Short THEN 1 ELSE 0 END AS 'Tue_WorkingDay'
,CASE WHEN t.Tue_WorkingDay = Day_Name_Short THEN TUE END AS 'Tue_WorkingHours'
,CASE WHEN t.Wed_WorkingDay = Day_Name_Short THEN 1 ELSE 0 END AS 'Wed_WorkingDay'
,CASE WHEN t.Wed_WorkingDay = Day_Name_Short THEN WED END AS 'Wed_WorkingHours'
,CASE WHEN t.Thu_WorkingDay = Day_Name_Short THEN 1 ELSE 0 END AS 'Thu_WorkingDay'
,CASE WHEN t.Thu_WorkingDay = Day_Name_Short THEN THU END AS 'Thu_WorkingHours'
,CASE WHEN t.Fri_WorkingDay = Day_Name_Short THEN 1 ELSE 0 END AS 'Fri_WorkingDay'
,CASE WHEN t.Fri_WorkingDay = Day_Name_Short THEN FRI END AS 'Fri_WorkingHours'
,CASE WHEN t.Sat_WorkingDay = Day_Name_Short THEN 1 ELSE 0 END AS 'Sat_WorkingDay'
,CASE WHEN t.Sat_WorkingDay = Day_Name_Short THEN SAT END AS 'Sat_WorkingHours'
,CASE WHEN t.Sun_WorkingDay = Day_Name_Short THEN 1 ELSE 0 END AS 'Sun_WorkingDay'
,CASE WHEN t.Sun_WorkingDay = Day_Name_Short THEN SUN END AS 'Sun_WorkingHours'
,HOURLY_RATE
,WEEKLY_HRS
FROM CTE_Test t
LEFT OUTER JOIN ELT.Dates d ON d.Date_Skey >= t.Earning_From_Date AND d.Date_Skey <= t.Earning_To_Date
)
SELECT 
cw.AssignmentEarningPatternHash
,AssignmentEarningPatternKey
,WorkingDayKey
--,Day_Name_Short
,CASE WHEN Day_Name_Short = 'Mon' THEN cw.Mon_WorkingHours
	  WHEN Day_Name_Short = 'Tue' THEN cw.Tue_WorkingHours
	  WHEN Day_Name_Short = 'Wed' THEN cw.Wed_WorkingHours
	  WHEN Day_Name_Short = 'Thu' THEN cw.Thu_WorkingHours
	  WHEN Day_Name_Short = 'Fri' THEN cw.Fri_WorkingHours
	  WHEN Day_Name_Short = 'Sat' THEN cw.Sat_WorkingHours
	  WHEN Day_Name_Short = 'Sun' THEN cw.Sun_WorkingHours
END AS 'Working_Hours'
,HOURLY_RATE
,WEEKLY_HRS
FROM cte_dates_worked cw
WHERE 
cw.Mon_WorkingDay = 1 
OR cw.Tue_WorkingDay = 1
OR cw.Wed_WorkingDay = 1
OR cw.Thu_WorkingDay = 1
OR cw.Fri_WorkingDay = 1
OR cw.Sat_WorkingDay = 1
OR cw.Sun_WorkingDay = 1

CREATE TABLE stg.DV_AssignmentPatternLinks_TEMP
			 WITH (CLUSTERED COLUMNSTORE INDEX, distribution = HASH(AssignmentEarningPatternHash))
AS

SELECT
SAAC.AssignmentEarningPatternHash
,S_AC.AssignmentHash
,SCAC.CaseHash
,SPACP.ParticipantHash	
,SEAC.EmployeeHash AS 'EmployeeHash'
,SRAC.ReferralHash 
,SPAC.ProgrammeHash 
,SDAC.DeliverySiteHash 
FROM 
DV.SAT_AssignmentEarningPattern_Adapt_Core SAAC
LEFT JOIN DV.LINK_Assignment_AssignmentEarningPattern aa ON aa.AssignmentEarningPatternHash = SAAC.AssignmentEarningPatternHash 
LEFT JOIN DV.SAT_Assignment_Adapt_Core S_AC ON S_AC.AssignmentHash = aa.AssignmentHash AND S_AC.IsCurrent = 1
LEFT JOIN DV.LINK_Case_Assignment ca ON ca.AssignmentHash = aa.AssignmentHash
LEFT JOIN DV.SAT_Case_Adapt_Core SCAC ON SCAC.CaseHash = ca.CaseHash AND SCAC.IsCurrent = 1
INNER JOIN DV.LINK_Case_Participant cp ON cp.CaseHash = ca.CaseHash
LEFT JOIN DV.SAT_Participant_Adapt_Core_PersonGen SPACP ON SPACP.ParticipantHash = cp.ParticipantHash AND SPACP.IsCurrent = 1
LEFT JOIN BV.LINK_Case_Employee ce ON ce.Case_EmployeeHash = ca.CaseHash
LEFT JOIN DV.SAT_Employee_Adapt_Core SEAC ON SEAC.EmployeeHash = ce.EmployeeHash AND SEAC.IsCurrent = 1
LEFT JOIN DV.LINK_Case_Referral cr ON cr.CaseHash = ca.CaseHash
LEFT JOIN DV.SAT_Referral_Adapt_Core SRAC ON SRAC.ReferralHash = cr.ReferralHash AND SRAC.IsCurrent = 1
LEFT JOIN DV.LINK_Referral_Programme rp ON rp.ReferralHash = cr.ReferralHash
LEFT JOIN DV.SAT_Programme_Adapt_Core SPAC ON SPAC.ProgrammeHash = rp.ProgrammeHash AND SPAC.IsCurrent = 1
LEFT JOIN BV.LINK_Case_DeliverySite cd ON cd.CaseHash = ca.CaseHash
LEFT JOIN DV.SAT_DeliverySite_Adapt_Core SDAC ON SDAC.DeliverySiteHash = cd.DeliverySiteHash AND SDAC.IsCurrent = 1
WHERE
SAAC.IsCurrent = 1


IF OBJECT_ID('[DV].[F_AssignmentEarnings]','U') IS NOT NULL TRUNCATE TABLE [DV].[F_AssignmentEarnings];

INSERT INTO [DV].[F_AssignmentEarnings] ([AssignmentEarningPatternHash],[AssignmentHash],[CaseHash],[ParticipantHash],[EmployeeHash],[ReferralHash],[ProgrammeHash],[DeliverySiteHash],[AssignmentEarningPatternKey],[WorkingDayKey],[Working_Hours],[Hourly_Rate],[Weekly_Hours])

SELECT
dat.AssignmentEarningPatternHash
,dapt.AssignmentHash
,dapt.CaseHash
,dapt.ParticipantHash
,dapt.EmployeeHash
,dapt.ReferralHash
,dapt.ProgrammeHash
,dapt.DeliverySiteHash
,dat.AssignmentEarningPatternKey
,dat.WorkingDayKey
,dat.Working_Hours
,dat.HOURLY_RATE AS 'Hourly_Rate'
,dat.WEEKLY_HRS AS 'Weekly_Hours'
FROM 
stg.DV_AssignmentEarningPattern_TEMP dat
INNER JOIN stg.DV_AssignmentPatternLinks_TEMP dapt ON dapt.AssignmentEarningPatternHash = dat.AssignmentEarningPatternHash

DROP TABLE stg.DV_AssignmentEarningPattern_TEMP;
DROP TABLE stg.DV_AssignmentPatternLinks_TEMP;

GO
