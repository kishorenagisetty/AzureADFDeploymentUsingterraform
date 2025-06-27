CREATE PROC [ELT].[usp_InsertRunLogTable] @PipelineRunID [VARCHAR](100),@LoadDate [DATETIME],@RunID [INT] OUT AS
BEGIN

SET @RunID = CAST(COALESCE((select max(RunID) from ELT.PipelineRunLog),0) + row_number() over (order by getdate()) as INT);

INSERT INTO ELT.[PipelineRunLog]
(
[RunID],
[PipelineRunID],
[LoadDate]
)
VALUES
(
@RunID,
@PipelineRunID ,
@LoadDate 
)

SELECT @RunID AS RunID

END
