CREATE VIEW [DV].[Fact_Case_Monthly_Analysis]
AS select [Date_Key], cf.* from
[DV].[Fact_Case_Base] cf
cross join [DV].[Dimension_Date] where Day_Of_Month = 1
and [Date_Key] Between [StartDateKey] And format(getdate()+730,'yyyyMMdd');
