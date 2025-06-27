CREATE VIEW [dwh].[fact_Barrier] AS 
-- Author: 
-- Create date: DD/MM/YYYY
-- Ticket Reference:  <Dev Ops Ticket Reference>
-- Description: <Description regarding object>
-- Revisions:
-- 19/01/2024 - <MK> - <32035> - <Added Barrier CreatedDate & Created By Columns>

select			convert(char(66),isnull(bar.BarriersHash ,cast(0x0 as binary(32))),1)							as BarrierHash
				,bar.RecordSource																				as RecordSource
				,convert(char(66),isnull(cba.CaseHash ,cast(0x0 as binary(32))),1)								as CaseHash
				,case when bac.BarrierEndDate is null then 1 else 0 end											as IsOpenBarrier
				,case when bac.BarrierEndDate is not null then 1 else 0 end										as IsClosedorComplete
				,case when bac.BarrierStatus <> '8253473' and bac.BarrierEndDate is not null then 1 else 0 end	as IsClosedBarrier
				,case when bac.BarrierStatus = '8253471' then 1 else 0 end										as IsNewBarrier
				,case when bac.BarrierStatus = '8253472' then 1 else 0 end										as IsInProgress
				,case when bac.BarrierStatus = '8253473' then 1 else 0 end										as IsComplete
				,bac.BarrierName																				as BarrierNameOrig
				,cast(mu1.ID as varchar(100))																	as BarrierCode
				,coalesce(nullif(mu1.Name,''),nullif(mu1.Description,''),'Unknown')								as BarrierName
				,bac.BarrierStartDate 																			as BarrierStartDate
				,bac.BarrierEndDate        																		as BarrierEndDate
				,su.FullName																					as BarrierCreatedBy		-- 19/01/24 <MK> <32035>
				,bac.BarrierCreatedDate																			as BarrierCreatedDate   -- 19/01/24 <MK> <32035>
				,case when ((coalesce(nullif(mu1.Name,''),nullif(mu1.Description,''),'Unknown') like '%Disengage%')				
							or (coalesce(nullif(mu1.Name,''),nullif(mu1.Description,''),'Unknown') like '%suspend engagement%')) then 1 else 0 end	as BarrierIsDisengagement
				,case when bac.BarrierEndDate is null then
						case when coalesce(nullif(mu1.Name,''),nullif(mu1.Description,''),'Unknown') like '%Disengage%'	then 'Disengaged'			
							 when coalesce(nullif(mu1.Name,''),nullif(mu1.Description,''),'Unknown') like '%suspend engagement%' then 'Suspend Engagement'
							 when coalesce(nullif(mu1.Name,''),nullif(mu1.Description,''),'Unknown') like '%Tailor%' then 'Tailored Engagement' 
						end		
				 end																							as DisengagementReason
				,case when bac.BarrierEndDate is null and ((coalesce(nullif(mu1.Name,''),nullif(mu1.Description,''),'Unknown') like '%Disengage%'			
						or coalesce(nullif(mu1.Name,''),nullif(mu1.Description,''),'Unknown') like '%suspend engagement%'
						or coalesce(nullif(mu1.Name,''),nullif(mu1.Description,''),'Unknown') like '%Tailor%')) then bac.BarrierStartDate  
				 end																							as DisengagementDate	
				,case when (coalesce(nullif(mu1.Name,''),nullif(mu1.Description,''),'Unknown') like '%Disengage%'			
						or coalesce(nullif(mu1.Name,''),nullif(mu1.Description,''),'Unknown') like '%suspend engagement%'
						or coalesce(nullif(mu1.Name,''),nullif(mu1.Description,''),'Unknown') like '%Tailor%') then bac.BarrierEndDate  
				 end																							as ReEngagementDate	
from			DV.HUB_Barriers					bar
left join		DV.LINK_Case_Barriers			cba on cba.BarriersHash = bar.BarriersHash 
left join		DV.SAT_Barriers_Adapt_Core		bac on bac.BarriersHash = cba.BarriersHash and bac.IsCurrent = 1
left join		DV.SAT_References_MDMultiNames	mu1 on mu1.ID = bac.BarrierName and mu1.Type = 'Code'
join			dwh.fact_Case					cas on cas.CaseHashBin	= cba.CaseHash
left join       ADAPT.vw_zSysUsers				su	on bac.BarrierCreatedBy = su.UserID and su.IsCurrent = 1
where			bar.RecordSource = 'ADAPT.PROP_BARRIER_GEN';