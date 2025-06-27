CREATE VIEW [dwh].[fact_CaseJourney] AS select		top 10000000
			gjd.CaseHash
			,left(gjd.Sankey,charindex('|',gjd.Sankey)-1)			as CaseJourney
			,substring(gjd.Sankey,charindex('|',gjd.Sankey)+1,100)	as CaseDestination
from		(select		cas.CaseHash
						,cast(case	when	cas.ReferralDate					is not null 
											and cas.StartDate					is not null
									then	'Referral Date|On Programme'
									when	cas.ReferralDate					is not null 
											and cas.StartDate					is null
											and cas.LeaveDate					is not null
											and cas.JobOutcomeOneClaimedDate	is null
									then	'Referral Date|Ref Left Programme'
									when	cas.ReferralDate					is not null 
											and cas.StartDate					is null
											and cas.LeaveDate					is null
											and cas.IsDisengaged				is not null
											and cas.JobOutcomeOneClaimedDate	is null
									then	'Referral Date|Ref Disengaged'
									when	cas.ReferralDate					is not null 
											and cas.StartDate					is null
											and cas.LeaveDate					is null
											and cas.IsDisengaged				is null
											and cas.JobOutcomeOneClaimedDate	is null
									then	'Referral Date|Waiting to be On Programme'
									when	cas.ReferralDate					is null
									then	null
									else	'Referral Date|Error'
							 end as varchar(250)) as Sankey1
						,cast(case	when	cas.ReferralDate					is not null 
											and cas.StartDate					is not null
											and cas.FirstJobStartDate			is not null
									then	'On Programme|First Job'
									when	cas.ReferralDate					is not null 
											and cas.StartDate					is not null
											and cas.FirstJobStartDate			is null
											and cas.LeaveDate					is not null
											and cas.JobOutcomeOneClaimedDate	is null
									then	'On Programme|OnProg Left Programme'
									when	cas.ReferralDate					is not null 
											and cas.StartDate					is not null
											and cas.FirstJobStartDate			is null
											and cas.LeaveDate					is null
											and cas.IsDisengaged				is not null
											and cas.JobOutcomeOneClaimedDate	is null
									then	'On Programme|OnProg Disengaged'
									when	cas.ReferralDate					is not null 
											and cas.StartDate					is not null
											and cas.FirstJobStartDate			is null
											and cas.LeaveDate					is null
											and cas.IsDisengaged				is null
											and cas.JobOutcomeOneClaimedDate	is null
									then	'On Programme|Waiting for First Job'
									when	cas.StartDate						is null
									then	null
									else	'On Programme|Error'
							 end as varchar(250)) as Sankey2
						,cast(case	when	cas.ReferralDate					is not null 
											and cas.StartDate					is not null
											and cas.FirstJobStartDate			is not null
											and cas.JobOutcomeOneClaimedDate	is not null
									then	'First Job|Claimed'
									when	cas.ReferralDate					is not null 
											and cas.StartDate					is not null
											and cas.FirstJobStartDate			is not null
											and cas.LeaveDate					is not null
											and cas.JobOutcomeOneClaimedDate	is null
									then	'First Job|Had Job Left Programme'
									when	cas.ReferralDate					is not null 
											and cas.StartDate					is not null
											and cas.FirstJobStartDate			is not null
											and cas.LeaveDate					is null
											and cas.IsDisengaged				is not null
											and cas.JobOutcomeOneClaimedDate	is null
									then	'First Job|Had Job Disengaged'
									when	cas.ReferralDate					is not null 
											and cas.StartDate					is not null
											and cas.FirstJobStartDate			is not null
											and cas.LeaveDate					is null
											and cas.IsDisengaged				is null
											and cas.JobOutcomeOneClaimedDate	is null
									then	'First Job|Waiting for Claim Date'
									when	cas.FirstJobStartDate				is null
									then	null
									else	'First Job|Error'
							 end as varchar(250)) as Sankey3
			from		dwh.fact_Case		cas
			join		dwh.dim_Programme	pro on pro.ProgrammeHash = cas.ProgrammeHash
			--where		pro.ProgrammeName = 'WHP Wales'
			) fcj
unpivot		(Sankey		for SankeyText in (fcj.Sankey1, fcj.Sankey2, fcj.Sankey3)) gjd
order by	gjd.CaseHash
			,cast(replace(gjd.SankeyText, 'Sankey','') as int);