CREATE VIEW [dwh].[dim_Employee] AS select		convert(char(66),isnull(emp.EmployeeHash,cast(0x0 as binary(32))),1)	as EmployeeHash
			,emp.RecordSource			as RecordSource
			,eac.EmployeeName			as EmployeeName
			,eac.EmployeeFirstName		as EmployeeFirstName
			,eac.EmployeeLastName		as EmployeeLastName
			,eac.EmployeeEmail			as EmployeeEmail
			,eac.JobTitle				as JobTitle
			,dda.DDATeam				as DDATeam
from		DV.HUB_Employee				emp
join		DV.SAT_Employee_Adapt_Core	eac on eac.EmployeeHash = emp.EmployeeHash and eac.IsCurrent = 1
left join	(select 'ADAPT|629288' as EmployeeKey,'Simon Balmont Fish' as EmployeeName,'Cardiff DDA' as DDATeam
			union all select 'ADAPT|9573205','Amber Denning','Cardiff DDA'
			union all select 'ADAPT|11276020','Maisie Meade','Cardiff DDA'
			union all select 'ADAPT|7289981','Katie Richards','Cardiff DDA'
			union all select 'ADAPT|9098522','Katie Smart','Cardiff DDA'
			union all select 'ADAPT|6881050','Christian Rickards','Cardiff DDA'
			union all select 'ADAPT|9087543','Meinir Williams','Cardiff DDA'
			union all select 'ADAPT|9186452','Kyle Hunt','Cardiff DDA'
			union all select 'ADAPT|11068052','Yuliia khotieieva','Cardiff DDA'
			union all select 'ADAPT|8695044','Khadra Sahal Roble','Cardiff DDA'
			union all select 'ADAPT|5101086','Rhiannon Jones','Caerphilly & Torfaen DDA'
			union all select 'ADAPT|10628441','Chiou Lee','Caerphilly & Torfaen DDA'
			union all select 'ADAPT|6711896','Craig Hamer','Caerphilly & Torfaen DDA'
			union all select 'ADAPT|6687280','Pauline Treweek','Caerphilly & Torfaen DDA'
			union all select 'ADAPT|629239','Kathy Lewis','Caerphilly & Torfaen DDA'
			union all select 'ADAPT|6979609','Sophie Griffiths','Caerphilly & Torfaen DDA'
			union all select 'ADAPT|7087821','Joanna Davies','Caerphilly & Torfaen DDA'
			union all select 'ADAPT|5270473','Carla Hillman ','Caerphilly & Torfaen DDA'
			union all select 'ADAPT|8119328','Adam Chappelle','Caerphilly & Torfaen DDA'
			union all select 'ADAPT|5184103','Natasha Osolinski','Caerphilly & Torfaen DDA'
			union all select 'ADAPT|629238','Kath Hackman','Newport & BG DDA'
			union all select 'ADAPT|629201','Clive Ward','Newport & BG DDA'
			union all select 'ADAPT|6826411','Sarah Clarke','Newport & BG DDA'
			union all select 'ADAPT|4593024','Jayne Morgan','Newport & BG DDA'
			union all select 'ADAPT|7093651','Jennifer Higgins','Newport & BG DDA'
			union all select 'ADAPT|8938677','Daniel Morgan','Newport & BG DDA'
			union all select 'ADAPT|8938487','Alexander Ellaway','Newport & BG DDA'
			union all select 'ADAPT|2342914','Julie Pedder','Newport & BG DDA'
			union all select 'ADAPT|1168671','Louise Lewis','Newport & BG DDA'
			union all select 'ADAPT|5043409','Michelle Forrest','Newport & BG DDA'
			union all select 'ADAPT|10896895','Aled Davies','Newport & BG DDA'
			union all select 'ADAPT|9243862','Eszter Ostodi','Newport & BG DDA'
			union all select 'ADAPT|629245','Layna Griffiths','Existing Merthyr & RCT DDA'
			union all select 'ADAPT|4493726','Lauren Thomas','Existing Merthyr & RCT DDA'
			union all select 'ADAPT|10421953','Huw Williams','Existing Merthyr & RCT DDA'
			union all select 'ADAPT|629197','Christine Morris','Existing Merthyr & RCT DDA'
			union all select 'ADAPT|924245','Rachel Sullivan','Existing Merthyr & RCT DDA'
			union all select 'ADAPT|5428532','Jodie Morris','Existing Merthyr & RCT DDA'
			union all select 'ADAPT|8392932','Colin Williams','Existing Merthyr & RCT DDA'
			union all select 'ADAPT|8775233','Michael Jenkins','Existing Merthyr & RCT DDA'
			union all select 'ADAPT|5092997','Sarah Murray','Existing Merthyr & RCT DDA'
			union all select 'ADAPT|7320138','Kathy Kelly','Existing Merthyr & RCT DDA'
			union all select 'ADAPT|8848544','Adrian Pope','Existing Merthyr & RCT DDA'
			union all select 'ADAPT|8484901','Leanne Price','Bridgend & Vale of Glamorgan DDA'
			union all select 'ADAPT|9666881','Jessica Hale-Summers','Bridgend & Vale of Glamorgan DDA'
			union all select 'ADAPT|8939028','Leah Richards','Bridgend & Vale of Glamorgan DDA'
			union all select 'ADAPT|5817026','Marion Dellimore','Bridgend & Vale of Glamorgan DDA'
			union all select 'ADAPT|629192','Caryn Williams','Bridgend & Vale of Glamorgan DDA'
			union all select 'ADAPT|11269747','Katie Rockell','Bridgend & Vale of Glamorgan DDA'
			union all select 'ADAPT|11454720','Natalia Karpenko-Watkins','Bridgend & Vale of Glamorgan DDA'
			union all select 'ADAPT|8020961','Hannah Hiddlestone','Bridgend & Vale of Glamorgan DDA'
			) as dda on dda.EmployeeKey = eac.EmployeeKey
where		emp.RecordSource			= 'ADAPT.PROP_EMPLOYEE_GEN';