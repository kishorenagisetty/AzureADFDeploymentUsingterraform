CREATE VIEW [ELT].[V_OPS_TEAM]
AS SELECT STRING_AGG(WorkEmail, '; ') AS recipients 
		FROM DW.D_Employee dw_d_e
		WHERE
			dw_d_e.FullName IN ('Liam Gant','Bhavisha Kukadia')
			AND dw_d_e.Leaver = 0;
