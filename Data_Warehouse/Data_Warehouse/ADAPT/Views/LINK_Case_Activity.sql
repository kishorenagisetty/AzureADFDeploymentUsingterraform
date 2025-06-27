CREATE VIEW [ADAPT].[LINK_Case_Activity] AS select
	concat_ws('|','ADAPT',cast(xpp.[reference] as int)) as CaseKey,
	concat_ws('|','ADAPT',cast(xap.[activity] as int)) as ActivityKey,
	'adapt.prop_wp_gen' as RecordSource
	,xap.ValidFrom
	,xap.ValidTo
	,xap.IsCurrent
from 
	adapt.prop_x_plan_progr xpp 
inner join 
	adapt.prop_x_act_plan xap 
on	xap.act_plan = xpp.act_plan
where	xap.IsCurrent = 1;
GO
