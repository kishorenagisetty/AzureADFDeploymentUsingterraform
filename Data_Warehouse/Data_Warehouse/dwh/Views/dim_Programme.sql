CREATE VIEW [dwh].[dim_Programme]
AS select		convert(char(66),isnull(pac.ProgrammeHash,cast(0x0 as binary(32))),1)	as ProgrammeHash
			,pro.RecordSource			as RecordSource
			,pac.ProgrammeName			as ProgrammeName
			,cast(null as varchar(50))	as ProgrammeGroup
			,cast(null as varchar(50))	as ProgrammeCategory
			,case when pac.ProgrammeName = 'WHP Self-Referral Introduction' then 'Yes' else 'No' end as SelfReferral
from		DV.HUB_Programme			pro
left join	DV.SAT_Programme_Adapt_Core	pac ON pac.ProgrammeHash = pro.ProgrammeHash and	pac.IsCurrent = 1
where		pro.RecordSource = 'ADAPT.PROP_WP_GEN';