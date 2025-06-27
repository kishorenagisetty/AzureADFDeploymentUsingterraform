CREATE VIEW [ADAPT].[LINK_Case_HMRC] AS (


SELECT
 [CaseKey], [HMRCKey], [RecordSource], [ValidFrom], [ValidTo], [IsCurrent]
FROM (
	SELECT 
	ROW_NUMBER() OVER(
					   PARTITION BY CONCAT_WS('|','ADAPT',CAST([REFERRAL NUMBER] AS INT),[NOTIFICATION TYPE]) 
					   ORDER BY pr.[REFERENCE] DESC)
					   AS RowNum,
	CONCAT_WS('|','ADAPT',CAST(pr.[REFERENCE] AS INT)) AS CaseKey,
	CONCAT_WS('|','ADAPT',CAST([REFERRAL NUMBER] AS INT),[NOTIFICATION TYPE])  AS HMRCKey,
	'ADAPT.EXTERNAL.XL'						AS RecordSource,
	hr.[ValidFrom],
	'9999-12-31 23:59:59' [ValidTo],
	pr.IsCurrent
	FROM (
	select * from (select ROW_NUMBER() OVER(
					   PARTITION BY CONCAT_WS('|','ADAPT',CAST([REFERRAL NUMBER] AS INT),[NOTIFICATION TYPE]) 
					   ORDER BY [NOTIFICATION DATE] DESC)
					   AS RowNum,
					   * from
	[LZ].[hmrc_Files]) sub where RowNum = 1) hr
	INNER JOIN ADAPT.PROP_CAND_PRAP pr ON pr.PRAP_REF = hr.[REFERRAL NUMBER]
	INNER JOIN [ADAPT].[LINK_Case_Participant] lcp on (CONCAT_WS('|','ADAPT',CAST(pr.[REFERENCE] AS INT)) = lcp.[CaseKey])
	WHERE
	pr.IsCurrent = 1 																				  
	--and CONCAT_WS('|','ADAPT',CAST(pr.[REFERENCE] AS INT)) in (select distinct [CaseKey] FROM [ADAPT].[LINK_Case_Participant])																					  )
	and [DATE CREATED] <> 'DATE CREATED'
  ) sub
 where RowNum = 1 -- JPC 11/08/2022 Ok, so we got some dups. I don't know the logic to remove them so have taken the last ID. Casll Logged to investigate
);
GO


