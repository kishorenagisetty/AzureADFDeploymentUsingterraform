CREATE PROC [DW].[BeforeCubeBuild] AS

exec DW.CSSEventLoad;

Truncate table	[dwh].[Fact_AssignmentEarnings];
insert into		[dwh].[Fact_AssignmentEarnings]
select * 
from			[dwh].[dim_Fact_AssignmentEarnings];

insert into ELT.DataPipelineComplete (DataLoadCompleteDate) select  convert(datetime, sysdatetimeoffset() at time zone 'GMT Standard Time');

go
