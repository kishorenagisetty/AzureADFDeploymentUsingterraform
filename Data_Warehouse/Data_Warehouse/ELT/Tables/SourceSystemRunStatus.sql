
CREATE TABLE [ELT].[SourceSystemRunStatus] (
    [SourceSystem]         VARCHAR (100)  NULL,
    [CurrentlyRunning]     BIT            NULL,
    [LastRunDateTime]      DATETIME       NULL,
    [ScaleupDWSize]        VARCHAR (100)  NULL,
    [ScaledownDWSize]      VARCHAR (100)  NULL,
    [SynpaseScaleLogicApp] VARCHAR (1000) NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);


--GO
--GRANT UPDATE
    --ON OBJECT::[ELT].[SourceSystemRunStatus] TO [UKMAXBIPRODDTBRKSDF01]
    --AS [dbo];


--GO
--GRANT UPDATE
    --ON OBJECT::[ELT].[SourceSystemRunStatus] TO [UKMAXBIPRODDF01]
    --AS [dbo];

