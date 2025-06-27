CREATE VIEW [REP].[dim_Date]
AS
-- ===============================================================
-- Author:	Sagar Kadiyala
-- Create date: 04/01/2024
-- Ticket Ref: #30330
-- Name: [REP].[dim_Date] 
-- Description: Date dimesion
-- Revisions:
-- 30330 - SK - 31/01/2024 - Create a new view to get date dimension
-- ===============================================================
    SELECT
            date_skey                                                          AS dim_date_id,
            CAST(full_date AS DATE)                                            AS [CalendarDate],
            YEAR(full_date)                                                    AS [CalendarYear],
            MONTH(full_date)                                                   AS [CalendarMonthInt],
            month_name_long                                                    AS [CalendarMonthName],
            day_of_month                                                       AS [CalendarDayInt],
            day_name_long                                                      AS [CalendarDayName],
            DATEPART(WEEKDAY, full_date)                                       AS [CalendarDayNameOrder],
            CASE
                WHEN CAST(full_date AS DATE) = CAST(GETDATE() AS DATE)
                    THEN 1
                ELSE
                    0
            END                                                                AS [IsToday],
            CAST(DATEADD(MONTH, DATEDIFF(MONTH, 0, full_date), 0) AS DATE)     AS [FirstDayofMonth],
            CAST(EOMONTH(full_date) AS DATE)                                   AS [LastDayofMonth],
            month_name_short + '-' + CAST((YEAR(full_date) - 2000) AS VARCHAR) AS [MMMyyName],
            month_name_short + '-' + CAST((YEAR(full_date) - 2000) AS VARCHAR) AS [MMMyyName (no drill)],
            CAST(FORMAT(full_date, 'yyyyMM') AS INT)                           AS MMMyy_order,
            is_weekend                                                         AS [IsWeekend],
            is_holiday                                                         AS [IsHoliday],
            is_business_day                                                    AS [IsBusinessDay],
            DATEDIFF(MONTH, full_date, GETDATE()) + 1                          AS [CohortMonthNumber], /*Cohort month count starts at 1 rather than 0*/
            CASE
                WHEN (DATEDIFF(MONTH, full_date, GETDATE()) + 1) > 18
                    THEN 'Past' /*Once cohort is more than 18 months old isconsidered closed*/
                WHEN (DATEDIFF(MONTH, full_date, GETDATE()) + 1) < 1
                    THEN 'Future'
                ELSE
                    'Current'
            END                                                                AS [Cohort Month Status]
    FROM
            DW.D_Date
    WHERE
            full_date
    between '01-Jan-2021' and '31-Dec-2027';