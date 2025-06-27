CREATE FUNCTION [dbo].[fn_WorkflowEventDurationAdd] (@DurationType [VARCHAR](50),@Duration [INT],@EventDate [DATETIME]) RETURNS DATETIME
AS
BEGIN  
    DECLARE @EventDateOut DATETIME;  
    SET @EventDateOut= 
					CASE
						WHEN @DurationType = 'Days'				THEN DATEADD(DAY,@Duration,@EventDate)
						WHEN @DurationType = 'Working Days'		THEN DATEADD(DAY,@Duration,@EventDate)
						WHEN @DurationType = 'Months'			THEN DATEADD(MONTH,@Duration,@EventDate)
						WHEN @DurationType = 'MonthsMinus1Day'  THEN DATEADD(DAY,-1,DATEADD(MONTH,@Duration,@EventDate))
						WHEN @DurationType = 'StageEndDays'		THEN DATEADD(DAY,@Duration,@EventDate)
					END
    RETURN(@EventDateOut);  
END
GO

