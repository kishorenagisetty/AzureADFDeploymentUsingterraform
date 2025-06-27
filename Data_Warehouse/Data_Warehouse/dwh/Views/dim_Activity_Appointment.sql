CREATE VIEW [dwh].[dim_Activity_Appointment] AS select			gfa.CaseHash
				,min(gfa.NextAppointmentDate)					as NextAppointmentDate
				,min(gfa.NextAppointmentType)					as NextAppointmentType
				,min(gfa.NextAppointmentContactMethod)			as NextAppointmentContactMethod
				,min(gfa.NextWFAAppointmentDate)				as NextWFAAppointmentDate
				,min(gfa.NextWFADueDate)						as NextWFADueDate
				,min(gfa.NextWPADueDate)						as NextWPADueDate
				,min(gfa.LastAppointmentDate)					as LastAppointmentDate
				,min(gfa.LastAppointmentType)					as LastAppointmentType
				,min(gfa.LastAppointmentContactMethod1)			as LastAppointmentContactMethod1
				,min(gfa.LastAppointmentContactMethod2)			as LastAppointmentContactMethod2
				,min(gfa.LastAppointmentContactMethod3)			as LastAppointmentContactMethod3
				,min(gfa.LastAppointmentContactMethod4)			as LastAppointmentContactMethod4
from			(select			fac.CaseHash					as CaseHash
								,fac.ActivityDueDate			as NextAppointmentDate
								,fac.ActivityType				as NextAppointmentType
								,fac.ActivityContactMethod		as NextAppointmentContactMethod
								,null							as LastAppointmentDate
								,null							as LastAppointmentType
								,null							as LastAppointmentContactMethod1
								,null							as LastAppointmentContactMethod2
								,null							as LastAppointmentContactMethod3
								,null							as LastAppointmentContactMethod4
								,null							as NextWFAAppointmentDate
								,null							as NextWFADueDate
								,null							as NextWPADueDate
				from			(select			act.CaseHash
												,act.ActivityHash
												,act.ActivityDueDate
												,act.ActivityType
												,act.ActivityContactMethod
												,row_number() over (partition by act.CaseHash order by act.CaseHash, act.ActivityDueDate) as rn 
								from			dwh.fact_Activity		act
								where			act.ActivityDueDate >= cast(getdate() as date) 
								and				act.ActivityCompleteDate is null) fac
				where			fac.rn = 1
				union all
				select			fac.CaseHash					as CaseHash
								,null							as NextAppointmentDate
								,null							as NextAppointmentType
								,null							as NextAppointmentContactMethod
								,case when fac.rn=1 
									  then fac.ActivityDueDate 
									  else null 
								end								as LastAppointmentDate
								,case when fac.rn=1 
									  then fac.ActivityType	
									  else null 
								 end							as LastAppointmentType
								,case when fac.rn=1 
									  then fac.ActivityContactMethod	
									  else null 
								 end							as LastAppointmentContactMethod1
								,case when fac.rn=2 
									  then fac.ActivityContactMethod	
									  else null 
								 end							as LastAppointmentContactMethod2
								,case when fac.rn=3 
									  then fac.ActivityContactMethod	
									  else null 
								 end							as LastAppointmentContactMethod3
								,case when fac.rn=4 
									  then fac.ActivityContactMethod	
									  else null 
								 end							as LastAppointmentContactMethod4
								,null							as NextWFAAppointmentDate
								,null							as NextWFADueDate
								,null							as NextWPADueDate
				from			(select			act.CaseHash
												,act.ActivityHash
												,act.ActivityDueDate
												,act.ActivityType
												,act.ActivityContactMethod
												,row_number() over (partition by act.CaseHash order by act.CaseHash, act.ActivityDueDate desc) as rn 
								from			dwh.fact_Activity		act
								where			act.ActivityDueDate < cast(getdate() as date)) fac
				where			fac.rn < 5
				union all
				select			fac.CaseHash					as CaseHash
								,null							as NextAppointmentDate
								,null							as NextAppointmentType
								,null							as NextAppointmentContactMethod
								,null							as LastAppointmentDate
								,null							as LastAppointmentType
								,null							as LastAppointmentContactMethod1
								,null							as LastAppointmentContactMethod2
								,null							as LastAppointmentContactMethod3
								,null							as LastAppointmentContactMethod4
								,fac.NextWFAStartDate			as NextWFAAppointmentDate
								,fac.NextWFADueDate				as NextWFADueDate
								,fac.NextWPADueDate				as NextWPADueDate
				from			(select			act.CaseHash
												,case when act.ActivityStartDate >= cast(getdate() as date)
													   and (isnull(act.ActivityName,'') like '%Work First Appraisal%' or isnull(act.ActivityName,'') like '%Working First Appraisal%') 
													  then act.ActivityStartDate
													  else null
												 end 			as NextWFAStartDate
												,case when act.ActivityDueDate >= cast(getdate() as date)
													   and (isnull(act.ActivityName,'') like '%Work First Appraisal%' or isnull(act.ActivityName,'') like '%Working First Appraisal%') 
													  then act.ActivityDueDate
													  else null
												 end 			as NextWFADueDate
												,case when act.ActivityDueDate >= cast(getdate() as date) 
												      and isnull(act.ActivityName,'') like '%Workplace Plan Appointment%'
													  then act.ActivityDueDate
													  else null
												 end 			as NextWPADueDate
								from			dwh.fact_Activity		act
								where			(act.ActivityStartDate >= cast(getdate() as date) or act.ActivityDueDate >= cast(getdate() as date))
								and				(    isnull(act.ActivityName,'') like '%Work First Appraisal%' 
												  or isnull(act.ActivityName,'') like '%Working First Appraisal%' 
												  or isnull(act.ActivityName,'') like '%Workplace Plan Appointment%')) fac
				) gfa
group by		gfa.CaseHash;