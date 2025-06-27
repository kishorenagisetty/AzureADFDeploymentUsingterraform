CREATE VIEW [dwh].[dim_HMRC_PingData] 
AS 
-- Author: 
-- Create date: DD/MM/YYY
-- Ticket Reference:  <Dev Ops Ticket Reference>
-- Description: <Description regarding object>
-- Revisions:
-- 14/08/2023 - <MK> - <26306> - <Ping 3 Criteria Changed as agreed with Paul Walters>
with			GetPings as (
select			hmc.RecordSource
				,convert(char(66),isnull(lch.CaseHash ,cast(0x0 as binary(32))),1)	as CaseHash
				,lch.CaseHash														as CaseHashBin
				,min(case when hac.NotificationType = 'FIRST_PAYMENT_DATE'			then cast(hac.NotificationDate as date) else null end) as Ping1Date
				,min(case when hac.NotificationType = 'EARNINGS_CROSSED_1000'		then cast(hac.NotificationDate as date) else null end) as Ping2Date
				,min(case when hac.NotificationType = 'EARNINGS_CROSSED_2000'		then cast(hac.NotificationDate as date) else null end) as Ping3Date
				,min(case when hac.NotificationType = 'EARNINGS_REACHED_THRESHOLD'	then cast(hac.NotificationDate as date) else null end) as Ping4Date
				,min(case when hac.NotificationType = 'END_OF_EMPLOYMENT'			then cast(hac.NotificationDate as date) else null end) as HMRC_EOE
from			DV.HUB_HMRC				hmc
left join		DV.SAT_HMRC_Adapt_Core	hac on hac.HMRCHash = hmc.HMRCHash and hac.IsCurrent = 1
left join		DV.LINK_Case_HMRC		lch on lch.HMRCHash = hmc.HMRCHash
group by		hmc.RecordSource
				,lch.CaseHash
)

select			pin.CaseHash							as CaseHash
				,pin.CaseHashBin						as CaseHashBin
				,pin.RecordSource						as RecordSource
				,pin.Ping1Date							as Ping1Date
				,pin.Ping2Date							as Ping2Date
				,pin.Ping3Date							as Ping3Date
				,pin.Ping4Date							as Ping4Date
				,pin.HMRC_EOE							as HMRC_EOE
				,case when pin.Ping1Date is null	 and pin.Ping2Date is null and pin.Ping3Date is null and pin.Ping4Date is null		then 1 else 0 end as Ping0DateCalc 
				,case when pin.Ping1Date is not null and pin.Ping2Date is null and pin.Ping3Date is null and pin.Ping4Date is null		then 1 else 0 end as Ping1DateCalc 
				,case when pin.Ping2Date is not null and pin.Ping3Date is null and pin.Ping4Date is null								then 1 else 0 end as Ping2DateCalc 
				--,case when pin.Ping3Date is not null and pin.Ping4Date is null														then 1 else 0 end as Ping3DateCalc
				,case when pin.Ping3Date is not null 																					then 1 else 0 end as Ping3DateCalc     -- 14/08/23 <MK> <26306>
				,case when pin.Ping4Date is not null																					then 1 else 0 end as Ping4DateCalc
				,case when pin.Ping1Date is null then 0 else 1 end
				 + case when pin.Ping2Date is null then 0 else 1 end
				 + case when pin.Ping3Date is null then 0 else 1 end
				 + case when pin.Ping4Date is null then 0 else 1 end as PingCount
				,datediff(dd, coalesce(pin.HMRC_EOE, pin.Ping4Date, pin.Ping3Date, pin.Ping2Date, pin.Ping1Date), getdate()) as DaysSinceLastPing

from			GetPings pin;