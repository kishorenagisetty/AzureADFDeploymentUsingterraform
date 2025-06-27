CREATE VIEW [ICONI].[SAT_DeliverySite_Iconi_Core] AS Select 
distinct
CONCAT_WS('|','ICONI',site_id) AS DeliverySiteKey,
CONCAT_WS('|',PS.ps_parent_agency_name,ps_site_name) as  DeliverySiteName,
cast(site_added_date as date) as ValidFrom,
'9999-12-31' as ValidTo,
1 as IsCurrent
FROM DELTA.[ICONI_vBIRestart_Site] S 
join DELTA.[ICONI_vBIRestart_ProjectSite] PS on
S.site_id = PS.ps_site_id;
GO
