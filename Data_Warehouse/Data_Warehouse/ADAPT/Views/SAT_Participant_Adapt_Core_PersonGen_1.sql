-- Author: 
-- Create date: DD/MM/YYY
-- Ticket Reference:  <Dev Ops Ticket Reference>
-- Description: <Description regarding object>
-- Revisions:
-- 13/10/2023 - <CH> - remove getdate

CREATE VIEW [ADAPT].[SAT_Participant_Adapt_Core_PersonGen] AS WITH cte_list AS 
(
SELECT  
	c.CODE_ID AS CodeID
	, c.PARENT_CODE_ID
	, c.NAME AS zValue
	, mn.DESCRIPTION AS zDescription
	, g.CONFIG_DISPLAY_NAME AS zList
	, d.zDescription AS zParent
  FROM ADAPT.[CODES] c
  INNER JOIN ADAPT.MD_MULTI_NAMES mn ON mn.ID = c.CODE_ID AND mn.[TYPE] = 'CODE' AND mn.IsCurrent = 1
  INNER JOIN ADAPT.CODE_GROUP_INDEX g ON g.GROUP_ID = c.GROUP_ID AND g.IsCurrent = 1
  LEFT OUTER JOIN
  (
	SELECT  
	c.CODE_ID AS CodeID
	, c.NAME AS zValue
	, mn.DESCRIPTION AS zDescription
	, g.CONFIG_DISPLAY_NAME AS zList
	, gc.NAME AS zParent
  FROM ADAPT.[CODES] c
  INNER JOIN ADAPT.MD_MULTI_NAMES mn ON mn.ID = c.CODE_ID AND mn.[TYPE] = 'CODE' AND mn.IsCurrent = 1
  INNER JOIN ADAPT.CODE_GROUP_INDEX g ON g.GROUP_ID = c.GROUP_ID AND g.IsCurrent = 1
  LEFT OUTER JOIN ADAPT.[CODES] gc ON gc.CODE_ID = c.PARENT_CODE_ID AND gc.IsCurrent = 1
  ) d ON d.CODEID = c.PARENT_CODE_ID
 ),cte_vac AS 
(
SELECT 
jc.REFERENCE 
,ISNULL(zParent,'Other') AS 'Vacancy_Goal'
,ROW_NUMBER() OVER (PARTITION BY jc.REFERENCE ORDER BY jc.BISUNIQUEID) RN
FROM ADAPT.PROP_JOB_CAT jc
INNER JOIN cte_list mn ON mn.CodeID = jc.JOB_Category
),cte_pivot AS 
(
SELECT 
REFERENCE
,MAX(CASE WHEN cte_vac.RN = 1 THEN cte_vac.Vacancy_Goal ELSE NULL END) AS VacancyGoal1
,MAX(CASE WHEN cte_vac.RN = 2 THEN cte_vac.Vacancy_Goal ELSE NULL END) AS VacancyGoal2
,MAX(CASE WHEN cte_vac.RN = 3 THEN cte_vac.Vacancy_Goal ELSE NULL END) AS VacancyGoal3
FROM cte_vac
WHERE RN < 4
GROUP BY 
REFERENCE
)
SELECT 
	CONCAT_WS('|','ADAPT',CAST(PG.PERSON_ID AS INT)) AS ParticipantKey,
	CONCAT_WS('|','ADAPT',CAST(PG.REFERENCE AS INT)) AS ParticipantEntityKey,
	PG.FULLNAME AS FullName,
	CAST(PG.TITLE AS INT) AS Title,
	PG.FIRST_NAME AS FirstName, 
	PG.MIDDLE_NAME AS MiddleName,
	PG.LAST_NAME AS LastName,
	PG.DT_OF_BIRTH AS DateOfBirth,
	DOC.DOCUMENT AS DisabilityNotes,
	VacancyGoal1,
	VacancyGoal2,
	VacancyGoal3,
	PG.ValidFrom,
	PG.ValidTo,
	PG.IsCurrent
	FROM ADAPT.PROP_PERSON_GEN PG
	INNER JOIN ADAPT.VW_LK_ENTITY_ROLE vr ON vr.REFERENCE = PG.REFERENCE AND vr.IsCurrent = '1'
	LEFT JOIN cte_pivot p ON p.REFERENCE = PG.REFERENCE
	LEFT JOIN 
	(
		SELECT *, ROW_NUMBER() OVER (PARTITION BY DOC.OWNER_ID ORDER BY DOC.UPDATED_DATE DESC) AS RN
		FROM ADAPT.vw_Documents_PSA DOC
		WHERE DOC.DOC_NAME in ('DisNote','DisabilityNotes') AND DOC.IsCurrent = 1
	) DOC  ON DOC.OWNER_ID = PG.REFERENCE	AND DOC.RN = 1;
GO
