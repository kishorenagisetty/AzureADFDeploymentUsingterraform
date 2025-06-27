CREATE VIEW [dwh].[dim_Participant] 
AS 

-- Author: Mohmed Kapadia
-- Modified date: DD/MM/YYY
-- Ticket Reference:  <25863>
-- Description: <Participant Dimension DWH View >
-- Revisions: 3
-- 05/07/2023 - <MK> - <25863> - <Further Logic Changed for Age Category>
-- 29/08/2023 - <MK> - <27268> - <Added Pref conctact method & Work telephone columns>

select		par.ParticipantHash															as ParticipantHashBin
			,convert(char(66),isnull(par.ParticipantHash,cast(0x0 as binary(32))),1)	as ParticipantHash			
			,par.RecordSource															as RecordSource
			,cast(par.ParticipantKey as varchar(25))									as ParticipantID
			,replace(cast(par.ParticipantKey as varchar(25)),'ADAPT|','')				as ParticipantIDNumber
			,pge.FullName
			,cge.HasUpToDateCV
			,cge.IsDriver
			,pay.NationalInsuranceNo													as NationalInsuranceNo
			,case when pay.NationalInsuranceNo is null then 'No' else 'Yes' end			as HasBankAccount
			,cge.HasCriminalConviction													as HasCriminalConviction
			,cge.HasOwnTransport														as HasOwnTransport
			,cge.BetterOffCalculationStatus
			,pge.DisabilityNotes														as DisabilityNotes
			,paa.AddressLine1
			,paa.AddressLine2
			,paa.Locality
			,paa.Town
			,paa.County
			,paa.PostCode
			,paa.PostCodeSector
			,tel.TelephoneMobile
			,tel.TelephoneHome
			,tel.TelephoneWork		-- 29/08/23 <MK> <27268>
			,pge.VacancyGoal1
			,pge.VacancyGoal2
			,pge.VacancyGoal3
			,ema.EmailWork
			,ema.EmailHome
			,case when ema.EmailHome is null then 'No' else 'Yes' end					as EmailStatus
			-- 05/07/23 < Mohmed Kapadia > <25863>
			,case when datediff(yy, cge.DOB, Cast(getdate() As Date)) < 16			  then 'Less Than 16'
				  when datediff(yy, cge.DOB, Cast(getdate() As Date)) between 16 and 18 then '16 To 18'
				  when datediff(yy, cge.DOB, Cast(getdate() As Date)) between 19 and 24 then '19 To 24'
				  when datediff(yy, cge.DOB, Cast(getdate() As Date)) between 25 and 30 then '25 To 30'
				  when datediff(yy, cge.DOB, Cast(getdate() As Date)) between 31 and 40 then '31 To 40'
				  when datediff(yy, cge.DOB, Cast(getdate() As Date)) between 41 and 50 then '41 To 50'
				  when datediff(yy, cge.DOB, Cast(getdate() As Date)) > 50			  then '50 Plus'
			 end																		as AgeCategory
			 ,mu1.[Description]															as Pref_COM_Method -- 29/08/23 <MK> <27268>

from		DV.HUB_Participant							par
left join	(select		ada.*
						,row_number() over (partition by ada.ParticipantHash order by ada.ParticipantHash, ada.ValidFrom desc) as rn 
			 from		DV.SAT_Participant_Adapt_Address ada
			 where		IsCurrent  = 1)					paa on paa.ParticipantHash = par.ParticipantHash	and paa.rn = 1
left join	DV.SAT_Participant_Adapt_Core_PersonGen		pge on pge.ParticipantHash = par.ParticipantHash	and pge.IsCurrent = 1
left join	DV.SAT_Participant_Adapt_Contact_Telephone	tel on tel.ParticipantHash = par.ParticipantHash	and tel.IsCurrent = 1
left join	DV.SAT_Participant_Adapt_Core_CandGen		cge on cge.ParticipantHash = par.ParticipantHash	and cge.IsCurrent = 1
left join	DV.SAT_Participant_Adapt_Core_CandPayroll	pay on pay.ParticipantHash = par.ParticipantHash	and pay.IsCurrent = 1
left join	(select		emm.* 
						,row_number() over (partition by emm.ParticipantHash order by emm.ParticipantHash, emm.ValidFrom desc) as rn
			from		DV.SAT_Participant_Adapt_Contact_Email emm
			where		emm.IsCurrent  = 1)				ema on ema.ParticipantHash = par.ParticipantHash	and ema.rn = 1
Left Join   DV.SAT_References_MDMultiNames				mu1 on mu1.ID = cge.PreferredCommunicationMethod	and mu1.IsCurrent = 1  and mu1.Type = 'Code' -- 29/08/23 <MK> <27268>
where		par.RecordSource = 'ADAPT.PROP_PERSON_GEN'
and			par.ParticipantKey <> 'ADAPT';