CREATE PROC [ELT].[sp_SAJobLog] @StartTime [DATETIME],@EndTime [DATETIME],@DurationSeconds [INT],@LoadDate [DATE],@Status [VARCHAR](10),@PipelineRunID [VARCHAR](100),@PipelineName [VARCHAR](100),@RunID [INT] OUT AS

BEGIN

SET @RunID = CAST(COALESCE((select max(RunID) from ELT.CTL_Load),0) + row_number() over (order by getdate()) as INT);
SET @Status = 'Running';
SET @LoadDate = CAST(@StartTime AS DATE);

INSERT INTO ELT.CTL_Load
        ( [RunID] ,
		  [StartTime] ,
          [EndTime] ,
          [DurationSeconds] ,
          [LoadDate] ,
          [Status],
		  [PipelineRunID],
		  [PipelineName]
        )
VALUES  ( @RunID			, -- RunID				- INT
		  @StartTime		, -- StartTime			- datetime
          @EndTime			, -- EndTime			- datetime
          @DurationSeconds	, -- DurationSeconds	- int
          @LoadDate			, -- LoadDate			- date
          @Status			, -- Status				- varchar(10)
          @PipelineRunID	, -- PipelineRunID		- varchar(100)
		  @PipelineName		  -- PipelineName		- varchar(100)
        )

SELECT @RunID AS RunID

END