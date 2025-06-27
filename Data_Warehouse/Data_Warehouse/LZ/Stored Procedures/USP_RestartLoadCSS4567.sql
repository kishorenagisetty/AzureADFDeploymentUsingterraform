CREATE PROC [LZ].[USP_RestartLoadCSS4567] AS

Set nocount on;

DECLARE @message NVARCHAR(max);
Set @Message = 'Drop #Tables';

RAISERROR(@Message,10,1) with NOWAIT;


if OBJECT_ID('tempdb..#StartDates') is not null
drop table #StartDates;
if OBJECT_ID('tempdb..#StartDates7') is not null
drop table #StartDates7;
if OBJECT_ID('tempdb..#MeetDatesByEng') is not null
drop table #MeetDatesByEng;
if OBJECT_ID('tempdb..#MeetDatesByEng7') is not null
drop table #MeetDatesByEng7;
if OBJECT_ID('tempdb..#MeetDates') is not null
drop table #MeetDates;
if OBJECT_ID('tempdb..#Meetings') is not null
drop table #Meetings;
if OBJECT_ID('tempdb..#DocDates') is not null
drop table #DocDates;

Set @Message = concat('#StartDates Load ',getdate()); RAISERROR(@Message,10,1) with NOWAIT;

create table #StartDates 
(
eng_tran_Date date,
eng_start_date date,
eng_end_date date,
engagement_id int
);

insert into #StartDates
(
eng_tran_Date,
eng_start_date,
eng_end_Date,
engagement_id
)

select
distinct
cast(eng_tran_date as date) as eng_tran_date,
cast(eng_start_date as date) as eng_start_date,
coalesce(eng_exit_Date,eng_left_Date) as eng_end_Date,
engagement_id

from lz.[Restart_vBIRestart_Engagement]
where eng_start_date is not null and
eng_did_not_Start_Date is null 
;

create table #StartDates7 
(
eng_start_date date,
eng_end_date date,
engagement_id int
);

insert into #StartDates7
(
eng_start_date,
eng_end_Date,
engagement_id
)

select
distinct
cast(eng_start_date as date) as eng_start_date,
coalesce(eng_exit_Date,eng_left_Date) as eng_end_Date,
engagement_id

from lz.[Restart_vBIRestart_Engagement] e
left join lz.[Restart_vBIRestart_Meeting] m
ON e.engagement_id = m.meet_engagement_id
and m.meet_type='4 Weekly Action Plan Review'
where eng_start_date is not null and
eng_did_not_Start_Date is null;


Set @Message = concat('#DocDates Load ',getdate());
RAISERROR(@Message,10,1) with NOWAIT;

create table #DocDates
(
engagement_id int,
[doc_date] date,
rnk int
);insert into #DocDates
(
engagement_id,
[doc_date],
rnk
)select distinct
rf_entity_id,
rf_added_date,
rf_version
from [LZ].[Restart_vBICommon_Document]
where rf_type = 'Signed 4 Weekly Action Plan'
;


Set @Message = concat('#MeetDatesByEng Load ',getdate());
RAISERROR(@Message,10,1) with NOWAIT;

create table #MeetDatesByEng
(
engagement_id int,
[Period_Start] date,
[Period_End] date,
rnk int,
CSSType char(4)
);

--------------------------------CSS4---------------------------------------------------------

insert into #MeetDatesByEng
(
engagement_id,
[Period_Start],
[Period_End],
rnk,
CSSType
)

select
engagement_id,
dateadd(dd,1,cast(eng_start_date as date)) as [Period_Start],
dateadd(dd,13,dateadd(dd,1,cast(eng_start_date as date))) as [Period_End],
1 as rnk,
'CSS4' as CSSType
from 
#StartDates

union all

select distinct 
meet_engagement_id as engagement_id,
cast(M.meet_date_time as date) as [Period_Start],
dateadd(dd,13,cast(M.meet_date_time as date)) as [Period_End],
row_number() over(partition by meet_engagement_id order by cast(M.meet_date_time as date) asc) +1 as rnk,
'CSS4' as CSSType

FROM [LZ].[Restart_vBIRestart_Meeting] M
join #StartDates sd on
sd.engagement_id = M.meet_engagement_id 
join  [LZ].[Restart_vBIRestart_Engagement] E on
E.Engagement_id = M.Meet_engagement_id

where  meet_type in('Fortnightly Review',
                                                          'Weekly Check-In',
                                                          'Springboard Review Meeting', 
                                                          '1st Month IWS Meetings', 
                                                          '3 Way Call with JCP Work Coach', 
                                                          '4 Month Diagnostic Re-assessment',
                                                          '4 Weekly Action Plan Review',
                                                          'Adhoc Appointment',
                                                          'Additional Contingency Support',
                                                          'Digital Support Meeting',
                                                          'Final F2F Action Plan Review',
                                                          'Job Start Appointment', 
                                                          'Rapid Response - Fell out of Work')
and M.[meet_date_time] is not null
and cast(M.meet_date_time as date) >= sd.eng_start_date

--------------------------------CSS5---------------------------------------------------------
insert into #MeetDatesByEng
(
engagement_id,
[Period_Start],
[Period_End],
rnk,
CSSType
)
select
engagement_id,
dateadd(dd,1,cast(eng_start_date as date)) as [Period_Start],
dateadd(dd,27,dateadd(dd,1,cast(eng_start_date as date))) as [Period_End],
1 as rnk,
'CSS5' as CSSType
from 
#StartDates
--where engagement_id = @EngID


union all
select distinct 
meet_engagement_id as engagement_id,
cast(M.meet_date_time as date) as [Period_Start],
dateadd(dd,27,cast(M.meet_date_time as date)) as [Period_End],
row_number() over(partition by meet_engagement_id order by cast(M.meet_date_time as date) asc) +1 as rnk,
'CSS5' as CSSType

FROM [LZ].[Restart_vBIRestart_Meeting] M
join #StartDates sd on
sd.engagement_id = M.meet_engagement_id 

where  meet_type in('4 Month Diagnostic Re-assessment',
                                                                        '4 Weekly Action Plan Review', 'Adhoc Appointment',
                                                                        'Additional Contingency Support',
                                                                        'Final F2F Action Plan Review')
and M.Meet_sub_type = 'Face-to-Face'
and M.[meet_date_time] is not null
and cast(M.meet_date_time as date) >= sd.eng_start_date
;
--------------------------------CSS6---------------------------------------------------------
insert into #MeetDatesByEng
(
engagement_id,
[Period_Start],
[Period_End],
rnk,
CSSType
)

select
ass_engagement_id as engagement_id,
diag.ass_Date as [Period_Start],
dateadd(dd,-1,dateadd(mm,4,cast(diag.ass_Date as date))) as [Period_End],
1 as rnk,
'CSS6' as CSSType
FROM [LZ].[Restart_vBIRestart_Assessment] A
join #StartDates SD on
SD.Engagement_id = A.Ass_engagement_id
outer apply
(
select min(cast(A1.ass_date_time as date)) as ass_date
from [LZ].[Restart_vBIRestart_Assessment] A1
where 
A1.ass_type = 'Diagnostic Assessment' and
cast(A1.ass_date_time as date) >= SD.eng_tran_date
and A.ass_engagement_id = A1.ass_engagement_id
)
as diag
where diag.ass_Date >= sd.eng_tran_date

union all

select distinct
meet_engagement_id as engagement_id,
cast(M.meet_date_time as date) as [Period_Start],
dateadd(dd,-1,dateadd(mm,4,cast(M.meet_date_time as date))) as [Period_End],
row_number() over(partition by meet_engagement_id order by cast(M.meet_date_time as date) asc) +1 as rnk,
'CSS6' as CSSType

FROM [LZ].[Restart_vBIRestart_Meeting] M
join #StartDates sd on
sd.engagement_id = M.meet_engagement_id

where meet_type in('4 Month Diagnostic Re-assessment', '8 Month Diagnostic Re-assessment')

and M.[meet_date_time] is not null
and cast(M.meet_date_time as date) >= sd.eng_start_date

--------------------------------CSS7---------------------------------------------------------

create table #MeetDatesByEng7
(
engagement_id int,
[Period_Start] date,
[Period_End] date,
[meet_action_plan_complete] nvarchar(5),
[meet_status] varchar(500),
rnk int,
CSSType char(4)
);

insert into #MeetDatesByEng7
(
engagement_id,
[Period_Start],
[Period_End],
[meet_action_plan_complete],
[meet_status],
rnk,
CSSType
)
select
engagement_id,
dateadd(dd,1,cast(eng_start_date as date)) as [Period_Start],
dateadd(dd,27,dateadd(dd,1,cast(eng_start_date as date))) as [Period_End],
null as meet_action_plan_complete,
null as meet_status,
1 as rnk,
'CSS7'
from
#StartDates7

union all

select distinct
meet_engagement_id as engagement_id,
cast(M.meet_date_time as date) as [Period_Start],
dateadd(dd,27,cast(M.meet_date_time as date)) as [Period_End],
meet_action_plan_complete,
meet_status,
row_number() over(partition by meet_engagement_id order by cast(M.meet_date_time as date) asc) +1 as rnk,
'CSS7'

FROM [LZ].[Restart_vBIRestart_Meeting] M
join #StartDates7 sd on
sd.engagement_id = M.meet_engagement_id 
where meet_type = '4 Weekly Action Plan Review'
and M.[meet_date_time] is not null
and (meet_status != 'Attended' or meet_status = 'Attended' and meet_action_plan_complete = 'Yes')
and cast(M.meet_date_time as date) >= sd.eng_start_date
;

---------------------------------------------------------------------------------------------

Set @Message = concat('#MeetDates Load ',getdate());
RAISERROR(@Message,10,1) with NOWAIT;

create table #MeetDates
(
Meet_Date date,
engagement_id int,
CSSType char(4),
[meet_action_plan_complete] nvarchar(5),
[meet_status] varchar(500)
);

insert into #MeetDates
(
Meet_Date,
engagement_id,
CSSType,
meet_action_plan_complete,
meet_status
)
select distinct
Period_Start as Meet_Date,
engagement_id,
CSSType,
null as meet_action_plan_complete,
null as meet_status
from
#MeetDatesByEng
where
rnk > 1

union all

select Distinct
Period_Start as Meet_Date,
engagement_id,
CSSType,
meet_action_plan_complete,
meet_status
from
#MeetDatesByEng7
where
rnk > 1
;

Set @Message = concat('#Meetings Load ',getdate());
RAISERROR(@Message,10,1) with NOWAIT;

Create table #Meetings 
(
[Period_Start] Date,
[Period_end] Date,
[QualifyingMeeting] Date,
engagement_id int,
CSSType char(4)
)

insert into #Meetings 
(
[Period_Start],
[Period_end],
[QualifyingMeeting],
engagement_id,
CSSType
)

select
distinct
case when  rnk > 1 then dateadd(dd,1,MDE.[Period_Start])
else MDE.[Period_Start]  end as [Period_Start],
case when  rnk > 1 then dateadd(dd,1,MDE.[Period_End]) else MDE.[Period_End]  end as [Period_end],
M.Meet_Date as [QualifyingMeeting],
engagement_id,
CSSType

from 
#MeetDatesByEng MDE

outer apply
(
Select top 1 
Meet_Date
from 
#MeetDates MD
where meet_date >= case when  rnk > 1 then dateadd(dd,1,MDE.[Period_Start])
else MDE.[Period_Start]  end

and Meet_Date <= case when  rnk > 1 then dateadd(dd,1,MDE.[Period_End]) else MDE.[Period_End]  end   and 
MD.Engagement_id = MDE.engagement_id and 
MDE.CSSType = MD.CSSType
) as M

union all

select
              [Period_Start],
              [Period_end],
              coalesce(
              case when M.meet_status != 'Attended' then M.Meet_Date else null end,
              case when M.meet_status = 'Attended' and isnull(M.[meet_action_plan_complete],'No') = 'Yes' then cast(D.doc_date as date) else null end
              ) as [QualifyingMeeting],
              engagement_id,
              CSSType

from (
              select
              distinct
              case when rnk > 1 then dateadd(dd,1,MDE.[Period_Start])
                             else MDE.[Period_Start] end as [Period_Start],
              case when rnk > 1 then dateadd(dd,1,MDE.[Period_End]) 
                             else MDE.[Period_End] end as [Period_end],
              MDE.meet_status,
              MDE.[meet_action_plan_complete],
              engagement_id,
              CSSType
              from
              #MeetDatesByEng7 MDE
) MDE
outer apply
(
Select 
top 1
Meet_Date,
meet_status,
meet_action_plan_complete
from
#MeetDates MD
where meet_date >= MDE.Period_Start
and MDE.Period_End >= Meet_Date and
MDE.Engagement_id = MD.engagement_id and
MDE.CSSType = MD.CSSType
) as M
outer apply
(
Select top 1
Doc_Date
from
#DocDates DD
where doc_date >= MDE.Period_Start
and MDE.Period_End >= doc_date and
MDE.Engagement_id = DD.engagement_id
) as D
;

Set @Message = concat('Main Insert ',getdate());
RAISERROR(@Message,10,1) with NOWAIT;



truncate table  LZ.[LZ_CSSAnalysis4567];

insert into  LZ.[LZ_CSSAnalysis4567]
(
Period_Start,
period_end,
QualifyingMeeting,
Engagement_id,
CSSType
)


select distinct

Period_Start,
Period_End,
[QualifyingMeeting],
M.Engagement_id,
CSSType

from #Meetings M
join #StartDates SD on
SD.Engagement_id = M.Engagement_id

where 
(SD.Eng_end_Date > Period_End or SD.Eng_end_Date is null)
and period_Start is not null

Set @Message = concat('End ',getdate());
RAISERROR(@Message,10,1) with NOWAIT;

