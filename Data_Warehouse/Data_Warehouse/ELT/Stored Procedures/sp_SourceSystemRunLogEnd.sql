create PROC [ELT].[sp_SourceSystemRunLogEnd] @SourceSystem [varchar](50),@LastCompletionDateTime [DATETIME],@CurrentlyRunning [bit] OUT AS

BEGIN

update ELT.SourceSystemRunStatus
set CurrentlyRunning = 0 where SourceSystem = @SourceSystem;

update ELT.SourceSystemRunStatus
set lastrundatetime = @LastCompletionDateTime where SourceSystem = @SourceSystem;

SELECT @CurrentlyRunning as CurrentlyRunning

END
