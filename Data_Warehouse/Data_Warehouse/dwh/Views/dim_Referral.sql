CREATE VIEW [dwh].[dim_Referral] AS select				convert(char(66),isnull(rac.ReferralHash,cast(0x0 as binary(32))),1)	as ReferralHash
					,ref.RecordSource														as RecordSource
					--,rst.ReferralStatus														as ReferralStatus
					,rac.PONumber															as PONumber
					,rac.PODescription														as PODescription
					,coalesce(nullif(mu1.Name,''),nullif(mu1.Description,''))				as ReferralType
					,cast(NULL as varchar(25))												as ReferralSourceOther
					,coalesce(nullif(mu2.Name,''),nullif(mu2.Description,''))				as Disability
					,rac.FastTrack															as FastTrack
					,coalesce(nullif(mu3.Name,''),nullif(mu3.Description,''))				as Incident
					,coalesce(nullif(mu4.Name,''),nullif(mu4.Description,''))				as WelshSpoken
					,coalesce(nullif(mu5.Name,''),nullif(mu5.Description,''))				as WelshWritten
					,cast(NULL as varchar(25))												as Occupation
					,cast(NULL as varchar(25))												as IsApprentice
					,rac.ReferringWorkCoach													as ReferringWorkCoach
					,trim(rac.ReferringJCP)													as ReferringJCP
from				DV.HUB_Referral						ref
join				[dwh].[fact_Case]					cas on cas.ReferralHashBin	= ref.ReferralHash
join				(select * from 
					  (select sr1.*,row_number() over (partition by sr1.ReferralHash order by sr1.ReferralHash, sr1.ReferralDate desc) as rn
					   from	DV.SAT_Referral_Adapt_Core sr1 where sr1.IsCurrent = 1) sr2
					 where sr2.rn = 1)					rac on rac.ReferralHash				= ref.ReferralHash and rac.IsCurrent = 1
left join			BV.LINK_Referral_ReferralStatus		lrr on lrr.ReferralHash				= rac.ReferralHash
left join			(select	distinct 
							convert(char(66),isnull(hashbytes('SHA2_256',rsr.ReferralStatus), 0x0),1) as ReferralStatusHash
							,cast(rsr.ReferralStatus as varchar(100)) AS ReferralStatus
					from	DV.ReferralStatusRules rsr)	rst on convert(char(66),isnull(rst.ReferralStatusHash,cast(0x0 as binary(32))),1) = convert(char(66),isnull(lrr.ReferralStatusHash,cast(0x0 as binary(32))),1)
left join			DV.SAT_References_MDMultiNames		mu1 on mu1.ID = rac.ReferralType	and mu1.IsCurrent = 1 and mu1.Type = 'Code'
left join			DV.SAT_References_MDMultiNames		mu2 on mu2.ID = rac.Disability		and mu2.IsCurrent = 1 and mu2.Type = 'Code'
left join			DV.SAT_References_MDMultiNames		mu3 on mu3.ID = rac.Incident		and mu3.IsCurrent = 1 and mu3.Type = 'Code'
left join			DV.SAT_References_MDMultiNames		mu4 on mu4.ID = rac.WelshSpoken		and mu4.IsCurrent = 1 and mu4.Type = 'Code'
left join			DV.SAT_References_MDMultiNames		mu5 on mu5.ID = rac.WelshWritten	and mu5.IsCurrent = 1 and mu5.Type = 'Code';