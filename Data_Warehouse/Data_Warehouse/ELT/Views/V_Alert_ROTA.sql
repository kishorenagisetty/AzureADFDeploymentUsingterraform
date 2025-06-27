CREATE VIEW [ELT].[V_Alert_ROTA] AS SELECT case when min (last_date)  >= (SELECT TOP(1) [Date]
									 FROM   [DW].[D_Date]
									 WHERE  [Date] > CAST(dateadd(month,datediff(month,0,getdate()),0) AS DATE)
											AND [is_business_day] = 1
									 ORDER  BY [Date]) 
			then 0 else 1 
	   end Alert
from (  
		SELECT  d_emp_h.Team,
			   MAX(d.[Date]) last_date
		FROM [DW].[F_Rota_History] f
			INNER JOIN DW.D_Date d ON d.Date_Skey = F.Date_Skey
			 INNER JOIN DW.D_Rota_History_Type d_rht 
				ON f.RotaHistoryType_Skey = d_rht.RotaHistoryType_Skey
			 INNER JOIN DW.D_Employee d_emp ON f.Employee_Skey = d_emp.Employee_Skey
			 INNER JOIN DW.D_Employee_History d_emp_h ON d_emp.Employee_Skey = d_emp_h.Employee_Skey
		WHERE
			d_rht.RotaHistoryType = 'Planned'
			and RotaType_Skey <> -1
			AND f.Sys_IsCurrent = 1
		GROUP BY
			d_emp_h.Team
	  ) subq;
