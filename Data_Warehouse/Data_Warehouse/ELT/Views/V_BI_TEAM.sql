CREATE VIEW [ELT].[V_BI_TEAM] AS SELECT STRING_AGG(WorkEmail, '; ') AS recipients 
		FROM DW.D_Employee dw_d_e
			INNER join DW.D_Employee_history  dw_d_eh
				on dw_d_e.Employee_Skey = dw_d_eh.Employee_Skey
		WHERE
			dw_d_eh.Team = 'BI Team'
			AND dw_d_e.Leaver = 0;
