CREATE PROC [ELT].[sp_SAJobUpdate] @EndTime [DATETIME],@DurationSeconds [INT],@Status [VARCHAR](10),@PipelineRunID [VARCHAR](100),@PipelineName [VARCHAR](100),@RunID [INT] AS

BEGIN

UPDATE	ELT.CTL_Load 
SET		[EndTime]			= @EndTime , 
		[Status]			= @Status, 
		[DurationSeconds]	= DATEDIFF(SS, [StartTime], @EndTime) 
WHERE	[RunID]				= @RunID

END