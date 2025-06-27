CREATE VIEW [dwh].[dim_Date] AS select		dat.Date_Skey
			,dat.Date
			,dat.Year_Number
			,dat.Month_Year_Name
			,dat.Year_Month_Number
			,dat.Day_Of_Month
			,dat.Fiscal_Year
			,dat.Fiscal_Quarter_Full_Name
			,case when dat.Year_Month_Number = cast(format(getdate(),'yyyyMM') as int) then 1 else null end as IsCurMonth
			,case when gtq.Fiscal_Quarter_Full_Name is null then null else 1 end as IsQuarter
			,case when gtd.Fiscal_Year is null then null else 1 end as IsFiscalYear
			--Job start Target (Dec 17-Oct 22 83.4%, Nov 22 onwards 54%)
			--Job Outcome Target (Dec 17 - Oct 22 = 52.5%, Nov 22 onwards = 34%)
			,case 
				when dat.Date between '1900-01-01' and '2022-10-31' then 0.834
				when dat.Date between '2022-11-01' and '2050-12-31' then 0.54
			 end as JobstartTarget
			,case 
				when dat.Date between '1900-01-01' and '2022-10-31' then 0.525
				when dat.Date between '2022-11-01' and '2050-12-31' then 0.34
			 end as JobOutcomeTarget
			,dat.Is_Business_Day
			,(select max(dpc.DataLoadCompleteDate) from ELT.DataPipelineComplete dpc) as DataLoadCompleteDate
from		DW.D_Date	dat
left join	(select		ddd.Date
						,ddd.Fiscal_Year
			from		DW.D_Date	ddd
			where		ddd.Month_Year_Name <> '*N/A*'
			and			ddd.Year_Number between 2017 and 2025
			and			ddd.Date = cast(getdate() as date)) gtd on gtd.Fiscal_Year = dat.Fiscal_Year
left join	(select		ddd.Date
						,ddd.Fiscal_Quarter_Full_Name
			from		DW.D_Date	ddd
			where		ddd.Month_Year_Name <> '*N/A*'
			and			ddd.Year_Number between 2017 and 2025
			and			ddd.Date = cast(getdate() as date)) gtq on gtq.Fiscal_Quarter_Full_Name = dat.Fiscal_Quarter_Full_Name
where		dat.Month_Year_Name <> '*N/A*'
and			dat.Year_Number between 2017 and 2025;