CREATE TABLE [DW].[D_Attrition_Reason] (
    [Attrition_Reason_Skey] INT           NOT NULL,
    [AttritionReasonBusKey] INT           NOT NULL,
    [AttritionType]         VARCHAR (255) NULL,
    [AttritionReason]       VARCHAR (255) NOT NULL,
    [Sys_LoadDate]          DATETIME      NOT NULL,
    [Sys_ModifiedDate]      DATETIME      NOT NULL,
    [Sys_RunID]             INT           NOT NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = REPLICATE);



