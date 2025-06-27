
CREATE VIEW [ADAPT].[SAT_Barriers_Adapt_Core] 
AS (
-- Author: 
-- Create date: DD/MM/YYYY
-- Ticket Reference:  <Dev Ops Ticket Reference>
-- Description: <Description regarding object>
-- Revisions:
-- 19/01/2024 - <MK> - <32035> - <Added Barrier CreatedDate & Created By Columns>
SELECT Distinct
CONCAT_WS('|','ADAPT',CAST([REFERENCE] AS INT)) AS BarrierKey, -- ADAPT.PROP_WP_GEN - Case Level
'ADAPT.PROP_BARRIER_GEN'						AS RecordSource,
[START_DT]			AS 'BarrierStartDate', 
[END_DT]			AS 'BarrierEndDate', 
pbg.[STATUS]		AS 'BarrierStatus', 
[BARRIER]			AS 'BarrierName',
et.[CREATEDDATE]	AS 'BarrierCreatedDate', -- 19/01/24 <MK> <32035>
et.[CREATED_BY]		AS 'BarrierCreatedBy',	 -- 19/01/24 <MK> <32035>
pbg.[ValidFrom], 
pbg.[ValidTo], 
pbg.IsCurrent 
FROM 
ADAPT.PROP_BARRIER_GEN pbg
Left Join ADAPT.ENTITY_TABLE et on pbg.[REFERENCE] = et.[ENTITY_ID] and et.IsCurrent = 1
);