CREATE VIEW [ADAPT].[SAT_Case_Adapt_Core]
AS 
-- Author: 
-- Create date: DD/MM/YYY
-- Ticket Reference:  <Dev Ops Ticket Reference>
-- Description: <Description regarding object>
-- Revisions:
-- DD/MM/YYY  - <>   - <#####> - <Initial Draft>
-- 09/10/2023 - <SK> - <27218> - <Adding 2 columns related to Strands>
SELECT 
CONCAT_WS('|','ADAPT',CAST(C.REFERENCE AS INT)) AS CaseKey,
CAST(C.STATUS		AS BIGINT) AS CaseStatus,
CAST(C.TASK_STATUS  AS BIGINT) AS CaseDevelopmentStatus,
CAST(C.MOD_STATUS	AS BIGINT) AS CaseModuleStatus,	
CAST(C.BENEF_STATUS AS BIGINT) AS PrimaryBenefit,
CAST(C.LEAVE_REASON AS BIGINT) AS LeaveReason,
CAST(C.WORK_STATUS	AS BIGINT) AS WorkRedinessStatus,
CAST(C.int_strand	AS BIGINT) AS InitStrand, -- 09/10/2023 - <SK> - <27218>
CAST(C.conf_strand	AS BIGINT) AS ConfStrand,-- 09/10/2023 - <SK> - <27218>
C.ValidFrom, C.ValidTo, C.IsCurrent
FROM ADAPT.PROP_WP_GEN C;