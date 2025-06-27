CREATE VIEW [ADAPT].[SAT_Activity_Adapt_Core] 
AS (
-- Author: 
-- Create date: DD/MM/YYY
-- Ticket Reference:  <Dev Ops Ticket Reference>
-- Description: <Description regarding object>
-- Revisions:
-- 23/08/2023 - <MK> - <26478> - <Added Activity Add Date>

SELECT 
CONCAT_WS('|','ADAPT',CAST([REFERENCE] AS INT)) AS ActivityKey,
'ADAPT.PROP_ACTIVITY_GEN'						AS RecordSource,
NAME AS 'ActivityName',
ET.CREATEDDATE AS 'ActivityAddDate', -- 23/08/23 <MK> <26478>
START_DATE AS 'ActivityStartDate',
DUE_DATE AS 'ActivityDueDate',
AC.STATUS AS 'ActivityStatus',
ACT_COM_DATE AS 'ActivityCompleteDate',
ASSIGNMENT AS 'ActivityRelatedAssignment',
ACT_TYPE AS 'ActivityType',
ACT_DESCRIPT AS 'ActivityDescription',
RLT_SP_NEED AS 'ActivityRelatedSupportNeed',
NUMB_OF_HRS AS 'ActivityHoursSpent',
HOURS_SCHED AS 'ActivityHoursScheduled',
OUTCOME AS 'ActivityOutcome',
CONT_METHOD AS 'ActivityContactMethod',
MAND_FIELD AS 'ActivityIsMandatory',
LTU AS 'ActivityIsLTURelated',
NEO AS 'ActivityIsNEORelated',
NEO_CODE AS 'ActivityNEOType',
VENUE AS 'ActivityVenue',
AC.[ValidFrom], 
AC.[ValidTo], 
Ac.IsCurrent 
FROM 
ADAPT.PROP_ACTIVITY_GEN AC
Left Join ADAPT.ENTITY_TABLE ET ON AC.REFERENCE = ET.ENTITY_ID and ET.IsCurrent = 1 -- 23/08/23 <MK> <26478>
);
GO