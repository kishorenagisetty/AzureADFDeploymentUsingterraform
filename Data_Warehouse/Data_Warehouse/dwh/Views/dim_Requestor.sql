CREATE VIEW [dwh].[dim_Requestor] AS select			distinct isnull(rso.RecordSource,rog.RecordSource)	as RecordSource
				,convert(char(66),
					case when isnull(rog.RequestingOrganisationHash,res.RequestingSiteHash) is null then cast(0x0 as binary(32))
					else cast(hashbytes('SHA2_256', concat(isnull(rog.RequestingOrganisationHash,cast(0x0 as binary(32))),isnull(res.RequestingSiteHash,cast(0x0 as binary(32))))) as binary(32))
					end ,1)											as RequestorHash
				,nullif(reo.RequestingOrganisation,'')				as RequestingOrganisation
				,nullif(reo.AddressLine1,'')						as RequestingOrganisation_AddressLine1
				,nullif(reo.AddressLine2,'')						as RequestingOrganisation_AddressLine2
				,nullif(reo.Town,'')								as RequestingOrganisation_Town
				,nullif(reo.County,'')								as RequestingOrganisation_County
				,nullif(reo.Country,'')								as RequestingOrganisation_Country
				,nullif(reo.PostCode,'')							as RequestingOrganisation_PostCode
				,nullif(reo.TelephoneNo,'')							as RequestingOrganisation_TelephoneNo
				,nullif(rac.RequestingSite,'')						as RequestingSite
				,nullif(rac.AddressLine1,'')						as RequestingSite_AddressLine1
				,nullif(rac.AddressLine2,'')						as RequestingSite_AddressLine2
				,nullif(rac.AddressLine3,'')						as RequestingSite_AddressLine3
				,nullif(rac.AddressLine4,'')						as RequestingSite_AddressLine4
				,nullif(rac.Town,'')								as RequestingSite_Town
				,nullif(rac.County,'')								as RequestingSite_County
				,nullif(rac.Country,'')								as RequestingSite_Country
				,nullif(rac.PostCode,'')							as RequestingSite_PostCode
from			DV.HUB_RequestingOrganisation						rog
left join		DV.LINK_RequestingSite_RequestingOrganisation		rso on rso.RequestingOrganisationHash	= rog.RequestingOrganisationHash
left join		DV.HUB_RequestingSite								res on res.RequestingSiteHash			= rso.RequestingSiteHash
left join		(select	*,row_number() over (partition by RequestingOrganisationHash order by ValidFrom desc) rn 
				 from	DV.SAT_RequestingOrganisation_Adapt_Core
				 where	IsCurrent = 1)								reo	on reo.RequestingOrganisationHash	= rog.RequestingOrganisationHash	and reo.rn = 1
left join		(select	*,row_number() over (partition by RequestingSiteHash order by ValidFrom, AddressLine1 desc) rn 
				 from	DV.SAT_RequestingSite_Adapt_Core
				 where	IsCurrent = 1)								rac	on rac.RequestingSiteHash			= res.RequestingSiteHash			and rac.rn = 1
where			rog.RecordSource = 'ADAPT.PROP_CAND_PRAP';