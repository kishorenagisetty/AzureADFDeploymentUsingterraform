CREATE VIEW [dwh].[dim_WorkflowEventsDrillThrough] AS select			cas.CaseHash						as CaseHash
				,cas.CaseID							as CaseID
				,cas.FirstJobstartDate				as FirstJobstartDate
				,cas.LeaveDate						as LeaveDate
				,cas.ProjectedLeaveDate				as ProjectedLeaveDate
				,del.DeliverySiteName				as DeliverySiteName
				,del.Zone							as Zone
				,del.ReportingZone					as ReportingZone
				,del.BaanRegion						as BaanRegion
				,del.DSRegion						as DSRegion
				,del.RegionSES						as RegionSES
				,del.DDA							as DDA
				,dis.IsDisengaged					as IsDisengaged
				,dis.BarrierName					as BarrierName
				,dis.BarrierStartDate				as BarrierStartDate
				,pro.ProgrammeName					as ProgrammeName
				,par.PostCodeSector					as PostCodeSector
				,ref.ReferringWorkCoach				as ReferringWorkCoach
				,ref.ReferringJCP					as ReferringJCP
				,par.ParticipantId					as ParticipantId
				,emp.EmployeeName					as EmployeeName
				,ref.ReferralType					as ReferralType
from			dwh.fact_case						cas							
left join		dwh.dim_DeliverySite				del on del.DeliverySiteHash = cas.DeliverySiteHash
left join		(select		bar.BarrierName			as BarrierName
							,bar.CaseHash			as CaseHash
							,bar.BarrierStartDate	as BarrierStartDate
							,case 
								when bar.BarrierIsDisengagement = 1 
								then 'Yes'
								else null
							 end					as IsDisengaged
							,row_number() over (partition by bar.CaseHash order by bar.BarrierStartDate desc) as rn
				from		dwh.fact_Barrier		bar
				where		bar.BarrierIsDisengagement	= 1
				and			bar.IsOpenBarrier = 1)	dis on dis.CaseHash =  cas.CaseHash
														and dis.rn = 1
left join		dwh.dim_Programme					pro on pro.ProgrammeHash	= cas.ProgrammeHash
left join		dwh.dim_Participant					par on par.ParticipantHash	= cas.ParticipantHash
left join		dwh.dim_Referral					ref on ref.ReferralHash		= cas.ReferralHash
left join		dwh.dim_Employee					emp	on emp.EmployeeHash		= cas.EmployeeHash;