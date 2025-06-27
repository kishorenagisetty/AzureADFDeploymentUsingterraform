CREATE VIEW [ADAPT].[SAT_Participant_Adapt_Industry] AS 

SELECT A.ParticipantKey
	 , A.Industry
	 , A.ValidFrom
	 , A.ValidTo
	 , A.IsCurrent
FROM
(
	SELECT 
	pac.ParticipantKey AS ParticipantKey,
	pis.Industry,
	ROW_NUMBER() OVER (PARTITION BY pis.REFERENCE ORDER BY pis.Industry DESC) AS rn,
	pis.ValidFrom,
	pis.ValidTo,
	pis.IsCurrent
	from			ADAPT.PROP_IND_SECT								pis
	left join		ADAPT.SAT_Participant_Adapt_Core_PersonGen		pac on pac.ParticipantEntityKey = concat_ws('|','ADAPT',cast(REFERENCE as int)) and pac.iscurrent = 1
	where			pac.ParticipantKey is not null
) A
WHERE rn = 1;