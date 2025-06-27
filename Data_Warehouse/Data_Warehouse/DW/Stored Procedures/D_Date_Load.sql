CREATE PROC [DW].[D_Date_Load] AS

------ -------------------------------------------------------------------
------ Script:         DW.D_Date Load (with version history)
------ Target:         Azure Synapse Data Warehouse
------ -------------------------------------------------------------------

------ Delete temporary tables if present.

if object_id ('stg.DW_D_Date_TEMP','U')  is not null drop table stg.DW_D_Date_TEMP;

-- -------------------------------------------------------------------
-- First TEMP table creates new versions of changing rows.
-- -------------------------------------------------------------------

-- Get dataset from Landing Zone
create  table stg.DW_D_Date_TEMP
        with (clustered columnstore index, distribution = replicate)
AS
WITH CTEIdx AS (
 SELECT [Date_Skey] [DateIdx],ROW_NUMBER() OVER(ORDER BY [Date_Skey] DESC) Idx
  FROM [ext].[D_Date]
  WHERE [Is_Business_Day] = 1 AND CASE 
		WHEN Date_Skey > 1 THEN cast(cast(Date_Skey as varchar(8)) as date)
		WHEN Date_Skey = 1 THEN '9999-12-31'
		ELSE '1899-12-30'
	END < CAST(GETDATE() AS DATE)
  UNION ALL
  SELECT [Date_Skey] [DateIdx],0 Idx
  FROM [ext].[D_Date]
  WHERE CASE 
		WHEN Date_Skey > 1 THEN cast(cast(Date_Skey as varchar(8)) as date)
		WHEN Date_Skey = 1 THEN '9999-12-31'
		ELSE '1899-12-30'
	END = CAST(GETDATE() AS DATE)
  UNION
  SELECT [Date_Skey] [DateIdx],-ROW_NUMBER() OVER(ORDER BY [Date_Skey]) Idx
  FROM [ext].[D_Date]
  WHERE [Is_Business_Day] = 1 AND  CASE 
		WHEN Date_Skey > 1 THEN cast(cast(Date_Skey as varchar(8)) as date)
		WHEN Date_Skey = 1 THEN '9999-12-31'
		ELSE '1899-12-30'
	END > CAST(GETDATE() AS DATE)
)
SELECT [Date_Skey],
	CASE 
		WHEN Date_Skey > 1 THEN cast(cast(Date_Skey as varchar(8)) as date)
		WHEN Date_Skey = 1 THEN '9999-12-31'
		ELSE '1899-12-30'
	END AS [Date]

	,CASE 
		WHEN Date_Skey > 1 THEN cast(cast(Date_Skey as varchar(8)) as datetime) 
		WHEN Date_Skey = 1 THEN '9999-12-31 00:00:00.000'
		ELSE '1899-12-30 00:00:00.000' 
	END AS Full_Date
	  ,[Date_Description]
      ,[Full_Date_Description]
      ,[Day_Of_Month]
      ,[Day_Of_Month_Suffix]
      ,[Day_Name_Short]
      ,[Day_Name_Long]
      ,[Week_Code]
      ,[Week_Number]
      ,[Week_Number_Full]
      ,[Month_Code]
      ,[Month_Name_Short]
      ,[Month_Name_Long]
      ,[Month_Number]
      ,[Month_Number_Full]
      ,[Quarter_Code]
      ,[Quarter_Number]
      ,[Quarter_Short_Name]
      ,[Quarter_Long_Name]
      ,[Semester_Code]
      ,[Semester_Number]
      ,[Semester_Short_Name]
      ,[Semester_Long_Name]
      ,[Year_Code]
      ,[Year_Number]
      ,[Year_Name]
      ,[Report_Period]
      ,[Rolling_Week]
      ,[Day_Reverse_Count_Key]
      ,[Day_Count_Key]
      ,[Fiscal_Year]
      ,[Fiscal_Year_Name]
      ,[Fiscal_Semester_Number]
      ,[Fiscal_Semester_Short_Name]
      ,[Fiscal_Semester_Long_Name]
      ,[Fiscal_Quarter_Number]
      ,[Fiscal_Quarter_Short_Name]
      ,[Fiscal_Quarter_Full_Name]
      ,[Fiscal_Month_Number]
      ,[Fiscal_Month_Full_Name]
      ,[Is_Calendar_Month_End]
      ,[Is_Accounting_Month_End]
      ,[Is_Calendar_Quarter_End]
      ,[Is_Calendar_Year_End]
      ,[Is_Accounting_Year_End]
      ,[Is_Business_Day]
      ,[Is_Holiday]
      ,[Is_Weekend]
      ,[Savings_Week]
      ,[Active_Performance_Period]
      ,[End_Of_Week_Date]
      ,[Month_Year_Name]
      ,[Day_Of_Month_Reversed]
      ,[CHDA_Contract_Year_Code]
      ,[CHDA_Contract_Year_Number]
      ,[CHDA_Contract_Year_Name]
      ,[CHDA_Contract_Month_Code]
      ,[CHDA_Contract_Month_Number_Full]
      ,[CHDA_Contract_Month_Number]
      ,[Year_Month_Number]
      ,[Year_Quarter_Number]
      ,[CHDA_Contract_Year_Month_Number]
      ,[CHDA_Contract_Year_Quarter_Number]
      ,[Previous_Year_Month_Number]
      ,[Business_Day_Of_Month]
      ,[Business_Day_Of_Month_Reversed]
      ,[Business_Days_In_Month]
      ,[End_Of_Week_Date_Sunday]
      ,[Non_Business_Days_In_Month]
      ,[Is_Business_Day_Scotland]
      ,[Is_Holiday_Scotland]
      ,[Business_Day_Of_Month_Scotland]
      ,[Business_Day_Of_Month_Reversed_Scotland]
      ,[Business_Days_In_Month_Scotland]
      ,[Non_Business_Days_In_Month_Scotland]
      ,[Holiday_Year]
      ,[Fiscal_Week_Number]
      ,[Calendar_Reporting_Month_Name]
      ,[Calendar_Reporting_Week_Number]
      ,[Fiscal_Week_Number_In_Month]
      ,[Fiscal_Month_Name]





	  	,CAST(CASE WHEN YEAR(GETDATE()) = [Year_Number] AND CASE 
		WHEN Date_Skey > 1 THEN cast(cast(Date_Skey as varchar(8)) as date)
		WHEN Date_Skey = 1 THEN '9999-12-31'
		ELSE '1899-12-30'
	END <= GETDATE() THEN 1 ELSE 0 END AS BIT) [This Year YTD] 

	 ,CAST(CASE WHEN YEAR(GETDATE())-1 = [Year_Number] AND CASE 
		WHEN Date_Skey > 1 THEN cast(cast(Date_Skey as varchar(8)) as date)
		WHEN Date_Skey = 1 THEN '9999-12-31'
		ELSE '1899-12-30'
	END <= DATEADD(YY,-1,GETDATE()) THEN 1 ELSE 0 END AS BIT) [Last Year YTD] 
	  ,CAST(CASE WHEN YEAR(GETDATE()) = [Year_Number] AND MONTH(GETDATE()) = [Month_Number] AND CASE 
		WHEN Date_Skey > 1 THEN cast(cast(Date_Skey as varchar(8)) as date)
		WHEN Date_Skey = 1 THEN '9999-12-31'
		ELSE '1899-12-30'
	END <= GETDATE() THEN 1 ELSE 0 END AS BIT) [Current Month MTD]
	  ,CAST(CASE WHEN YEAR(DATEADD(M,-1,GETDATE())) = [Year_Number] AND MONTH(DATEADD(M,-1,GETDATE())) = [Month_Number] THEN 1 ELSE 0 END AS BIT)[Last Full Month]
	  ,CAST(CASE WHEN YEAR(GETDATE())-1 = [Year_Number] THEN 1 ELSE 0 END AS BIT) [Last Full Year] 
	  ,i.[Idx] [Working Days Index Field]
	  
	  
	  
	  
	  
	  ,CASE WHEN [Fiscal_Week_Number] = (SELECT d2.[Fiscal_Week_Number] FROM [ext].[D_Date] d2 WHERE 
	  CASE 
		WHEN d2.Date_Skey > 1 THEN cast(cast(d2.Date_Skey as varchar(8)) as date)
		WHEN d2.Date_Skey = 1 THEN '9999-12-31'
		ELSE '1899-12-30'
	END = CAST(DATEADD(D,-7,GETDATE()) AS DATE)) 
		AND YEAR(CAST(DATEADD(D,-7,GETDATE()) AS DATE)) = [Year_Number]
		THEN 1 ELSE 0 END [Last Full Week]
	  
	  
	  
	  
	  ,CASE WHEN [Quarter_Code] = 
		  (SELECT d4.[Quarter_Code] FROM [ext].[D_Date] d4 WHERE CASE 
								WHEN d4.Date_Skey > 1 THEN cast(cast(d4.Date_Skey as varchar(8)) as date)
								WHEN d4.Date_Skey = 1 THEN '9999-12-31'
								ELSE '1899-12-30'
							END =
			  (SELECT DATEADD(D,-1,MIN(CASE 
								WHEN d3.Date_Skey > 1 THEN cast(cast(d3.Date_Skey as varchar(8)) as date)
								WHEN d3.Date_Skey = 1 THEN '9999-12-31'
								ELSE '1899-12-30'
							END)) FROM [ext].[D_Date] d3 WHERE d3.[Quarter_Code] 
					= (SELECT d2.[Quarter_Code] FROM [ext].[D_Date] d2 WHERE CASE 
								WHEN d2.Date_Skey > 1 THEN cast(cast(d2.Date_Skey as varchar(8)) as date)
								WHEN d2.Date_Skey = 1 THEN '9999-12-31'
								ELSE '1899-12-30'
							END = CAST(GETDATE() AS DATE) ) )
				)
				THEN 1 ELSE 0 END [Last Full Quarter]
	  
	  
	  
	  
	  ,CASE WHEN [Fiscal_Quarter_Full_Name] = 
	  (SELECT d4.[Fiscal_Quarter_Full_Name] FROM [ext].[D_Date] d4 WHERE CASE 
								WHEN d4.Date_Skey > 1 THEN cast(cast(d4.Date_Skey as varchar(8)) as date)
								WHEN d4.Date_Skey = 1 THEN '9999-12-31'
								ELSE '1899-12-30'
							END =
	  (SELECT DATEADD(D,-1,MIN(CASE 
								WHEN d3.Date_Skey > 1 THEN cast(cast(d3.Date_Skey as varchar(8)) as date)
								WHEN d3.Date_Skey = 1 THEN '9999-12-31'
								ELSE '1899-12-30'
							END)) FROM [ext].[D_Date] d3 WHERE d3.[Fiscal_Quarter_Full_Name] 
			= (SELECT d2.[Fiscal_Quarter_Full_Name] FROM [ext].[D_Date] d2 WHERE CASE 
								WHEN d2.Date_Skey > 1 THEN cast(cast(d2.Date_Skey as varchar(8)) as date)
								WHEN d2.Date_Skey = 1 THEN '9999-12-31'
								ELSE '1899-12-30'
							END = CAST(GETDATE() AS DATE) ) )
		)
		THEN 1 ELSE 0 END [Last Full Financial Year Quarter]
	  
	  






	  ,[Fiscal_Month_Number] [Financial Year Month Number]
	  ,DATEDIFF(D,CAST(GETDATE() AS DATE),CASE 
		WHEN Date_Skey > 1 THEN cast(cast(Date_Skey as varchar(8)) as date)
		WHEN Date_Skey = 1 THEN '9999-12-31'
		ELSE '1899-12-30'
	END) [DayIndex]
	  ,DATEDIFF(MM,CAST(GETDATE() AS DATE),CASE 
		WHEN Date_Skey > 1 THEN cast(cast(Date_Skey as varchar(8)) as date)
		WHEN Date_Skey = 1 THEN '9999-12-31'
		ELSE '1899-12-30'
	END) [MonthIndex]
	  ,DATEDIFF(YY,CAST(GETDATE() AS DATE),CASE 
		WHEN Date_Skey > 1 THEN cast(cast(Date_Skey as varchar(8)) as date)
		WHEN Date_Skey = 1 THEN '9999-12-31'
		ELSE '1899-12-30'
	END)[YearIndex]





	  ,GETDATE() AS [Created_Date]
	  ,GETDATE()  AS [Modified_Date]
	  ,'DW_load' AS [Created_By]
      ,'DW_load' AS [Modified_By]
	FROM [ext].[D_Date] d
  LEFT JOIN CTEIdx i ON i.[DateIdx] = d.[Date_Skey]
OPTION (LABEL = 'CTAS : Load [dw].[D_Date]')
;

-- Create NOT NULL constraint on temp
alter table stg.DW_D_Date_TEMP
ALTER COLUMN Date_SKey INT NOT NULL

-- Create primary key on temp
ALTER TABLE stg.[DW_D_Date_TEMP]
ADD CONSTRAINT PK_Date_skey PRIMARY KEY NONCLUSTERED (Date_skey) NOT ENFORCED

ALTER TABLE stg.[DW_D_Date_TEMP]
ALTER COLUMN [Last Full Week] INT NULL

ALTER TABLE stg.[DW_D_Date_TEMP]
ALTER COLUMN [Last Full Quarter] INT NULL

ALTER TABLE stg.[DW_D_Date_TEMP]
ALTER COLUMN [Last Full Financial Year Quarter] INT NULL

-- Switch table contents replacing target with temp.

alter table DW.D_Date switch to OLD.DW_D_Date with (truncate_target=on);
alter table stg.DW_D_Date_TEMP switch to DW.D_Date with (truncate_target=on);

drop table stg.DW_D_Date_TEMP;

-- Force replication of table.
select  top 1 * from DW.D_Date order by Date_Skey; 