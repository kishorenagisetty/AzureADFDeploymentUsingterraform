CREATE VIEW [ADAPT].[CODES_HUB_Rebuild] AS with				source_config as 
(
	select			map.ObjectMappingID
					,map.SourceTable
					,map.DestinationTable
	from			elt.DVObjectMapping map
	where			map.SourceSchema = 'ADAPT'
	and				map.IsEnabled = 1
	and				substring(map.SourceTable, 1, 4) = 'HUB_'
)
,					destination_table as
(
	select			sco.ObjectMappingId	as ObjectMappingId
					,tab.name			as table_name
					,col.name			as column_name
					,col.column_id		as column_ordinal
	from			sys.tables			tab
	inner join		sys.columns			col on col.object_id = tab.object_id
	inner join		source_config		sco on sco.DestinationTable = tab.name and schema_name(tab.[schema_id]) = 'DV'
)
,					source_view as 
(
	select			sco.ObjectMappingId	as ObjectMappingId
					,tab.name			as table_name
					,col.name			as column_name
					,col.column_id		as column_ordinal
	from			sys.views			tab
	inner join		sys.columns			col on col.object_id = tab.object_id
	inner join		source_config		sco on sco.SourceTable = tab.name and schema_name(tab.[schema_id]) = 'ADAPT'
)
,					source_select as
(
	select			det.ObjectMappingId
					,det.table_name as destination_table_name
					,det.column_name
					,det.column_ordinal
					,nss.table_name as source_view_name
					,nss.column_name as source_column_name
					,case
						when det.column_ordinal = 1 then 'CAST(HASHBYTES(''SHA2_256'', ISNULL(CAST(' + nss.column_name + ' AS NVARCHAR(100)),'''')) AS BINARY(32)) AS ' + det.column_name
						when nss.column_name = det.column_name then ',' + det.column_name
						else ',' + nss.column_name + ' as ' + det.column_name
					end as select_line
	from			destination_table as det
	inner join		(select		sv1.ObjectMappingId
								,sv1.table_name
								,sv1.column_name
								,sv1.column_ordinal
					from		source_view	sv1
					where		sv1.column_ordinal = 1
					union all
					select		sv2.ObjectMappingId
								,sv2.table_name
								,sv2.column_name
								,sv2.column_ordinal + 1 as column_ordinal
					from		source_view sv2
					) nss on nss.ObjectMappingId = det.ObjectMappingId and nss.column_ordinal = det.column_ordinal
)
,					group_by_list as
(
	select			det.ObjectMappingId
					,string_agg(det.column_name, ', ') within group (order by det.column_ordinal asc) as field_list
	from			destination_table det
	where			det.column_name <> 'ValidFrom'
	group by		det.ObjectMappingId
)



select				'Hub' as 'TableType'
					,daa.ObjectMappingId
					,concat('truncate table DV.',daa.destination_table_name,'; insert into DV.',daa.destination_table_name,' select	',gbl.field_list,' ,min(ValidFrom) as ValidFrom from (select ',daa.all_select,' from ADAPT.',daa.source_view_name,') as a group by ',gbl.field_list,';') as rebuild_statement
from				(select		sos.ObjectMappingId
								,sos.destination_table_name
								,sos.source_view_name
								,string_agg(sos.select_line, ' ') within group (order by sos.column_ordinal asc) as all_select
					 from		source_select	sos
					 group by	sos.ObjectMappingId
								,sos.destination_table_name
								,sos.source_view_name)	daa
inner join			group_by_list	gbl on gbl.ObjectMappingId = daa.ObjectMappingId
where				daa.destination_table_name is not null
and					gbl.field_list is not null
and					daa.all_select is not null
and					daa.source_view_name is not null
and					gbl.field_list is not null;