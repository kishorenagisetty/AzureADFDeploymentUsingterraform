create PROC [ELT].[sp_SourceSystemRunLogStart] @SourceSystem [varchar](50),@CurrentlyRunning [bit] OUT AS

BEGIN

update ELT.SourceSystemRunStatus

set CurrentlyRunning = 1 where SourceSystem = @SourceSystem;

SELECT @CurrentlyRunning as CurrentlyRunning

END
