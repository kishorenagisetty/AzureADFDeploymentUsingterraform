
CREATE FUNCTION [dbo].[fn_DateAdd2] (@DatePart_VC [VARCHAR](20),@Number_IN [INT],@Date_DT [DATETIME]) RETURNS DATETIME
AS
BEGIN
    -- Declare the return variable here
    DECLARE @Return_DT DATETIME =

    -- Add the T-SQL statements to compute the return value here
        CASE 
            WHEN @DatePart_VC = 'Year'			THEN DATEADD(year,@Number_IN,@Date_DT)
            WHEN @DatePart_VC = 'Quarter'		THEN DATEADD(quarter,@Number_IN,@Date_DT)
            WHEN @DatePart_VC = 'Month'			THEN DATEADD(month,@Number_IN,@Date_DT)
            WHEN @DatePart_VC = 'Dayofyear'		THEN DATEADD(dayofyear,@Number_IN,@Date_DT)
            WHEN @DatePart_VC = 'Day'			THEN DATEADD(day,@Number_IN,@Date_DT)
            WHEN @DatePart_VC = 'Week'			THEN DATEADD(week,@Number_IN,@Date_DT)
            WHEN @DatePart_VC = 'Weekday'		THEN DATEADD(weekday,@Number_IN,@Date_DT)
            WHEN @DatePart_VC = 'Hour'			THEN DATEADD(hour,@Number_IN,@Date_DT)
            WHEN @DatePart_VC = 'Minute'		THEN DATEADD(minute,@Number_IN,@Date_DT)
            WHEN @DatePart_VC = 'Second'		THEN DATEADD(second,@Number_IN,@Date_DT)

		-- Custom DatePart
			WHEN @DatePart_VC = 'MonthMinusDay'	THEN DATEADD(day,-1,DATEADD(month,@Number_IN,@Date_DT))
            --WHEN @DatePart_VC = 'millisecond' THEN DATEADD(millisecond,@Number_IN,@Date_DT)
            --WHEN @DatePart_VC = 'microsecond' THEN DATEADD(microsecond,@Number_IN,@Date_DT)
            --WHEN @DatePart_VC = 'nanosecond' THEN DATEADD(nanosecond,@Number_IN,@Date_DT)

        END

    -- Return the result of the function
    RETURN @Return_DT
END
GO