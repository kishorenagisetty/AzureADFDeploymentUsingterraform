CREATE PROC [DV].[TruncateRebuildHubSatLink] AS

declare @ObjectMappingId int = 0;
declare @RunSQL nvarchar(max) = '';

--Truncate and rebuild the Hub tables
if object_id('tempdb..#HubTable') is not null drop table #HubTable;
select * into #HubTable from ADAPT.CODES_HUB_Rebuild;  
set @ObjectMappingId = 0;
set @RunSQL = '';
while (1 = 1) 
begin 
  if (select count(*) from #HubTable where ObjectMappingId > @ObjectMappingId) = 0 break;
  select top 1	@ObjectMappingId = ObjectMappingId
				,@RunSQL = rebuild_statement
  from			#HubTable
  WHERE			ObjectMappingId > @ObjectMappingId 
  order by		ObjectMappingId;
  --select @RunSQL = 'select ' + cast(@ObjectMappingId as varchar(250));
  exec sp_executesql @RunSQL;
end

--Truncate and rebuild the Sat tables
if object_id('tempdb..#SatTable') is not null drop table #SatTable;
select * into #SatTable from ADAPT.CODES_SAT_Rebuild;  
set @ObjectMappingId = 0;
set @RunSQL = '';
while (1 = 1) 
begin 
  if (select count(*) from #SatTable where ObjectMappingId > @ObjectMappingId) = 0 break;
  select top 1	@ObjectMappingId = ObjectMappingId
				,@RunSQL = rebuild_statement
  from			#SatTable
  WHERE			ObjectMappingId > @ObjectMappingId 
  order by		ObjectMappingId;
  --select @RunSQL = 'select ' + cast(@ObjectMappingId as varchar(250));
  exec sp_executesql @RunSQL;
end

--Truncate and rebuild the Link tables
if object_id('tempdb..#LinkTable') is not null drop table #LinkTable;
select * into #LinkTable from ADAPT.CODES_LINK_Rebuild;  
set @ObjectMappingId = 0;
set @RunSQL = '';
while (1 = 1) 
begin 
  if (select count(*) from #LinkTable where ObjectMappingId > @ObjectMappingId) = 0 break;
  select top 1	@ObjectMappingId = ObjectMappingId
				,@RunSQL = rebuild_statement
  from			#LinkTable
  WHERE			ObjectMappingId > @ObjectMappingId 
  order by		ObjectMappingId;
  --select @RunSQL = 'select ' + cast(@ObjectMappingId as varchar(250));
  exec sp_executesql @RunSQL;
end

----Truncate and rebuild the SATLINK tables
--truncate table dv.LINKSAT_Case_Employee_Adapt_Core
--exec DV.usp_Load_LinkSat @ObjectMappingID = 88,  @debug = 0; --LINKSAT_Case_Employee_Adapt_Core

--truncate table dv.LINKSAT_Case_Assignment_Adapt_Core
--exec DV.usp_Load_LinkSat @ObjectMappingID = 175, @debug = 0; --LINKSAT_Case_Assignment_Adapt_Core