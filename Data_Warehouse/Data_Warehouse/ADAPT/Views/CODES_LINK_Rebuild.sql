CREATE VIEW [ADAPT].[CODES_LINK_Rebuild] AS with				source_config as 
(
	select			map.ObjectMappingID
					,map.SourceTable
					,map.DestinationTable
	from			elt.DVObjectMapping map
	where			map.SourceSchema = 'ADAPT'
	and				map.IsEnabled = 1
	and				substring(map.SourceTable, 1, 5) = 'LINK_'
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
,					link_hash			as
(
	select			sov.objectMappingID
					,'cast(HASHBYTES(''SHA2_256'',concat(' + string_agg('ISNULL(CAST(' + sov.column_name + ' AS NVARCHAR(100)),'''')', ',') within group (order by sov.column_ordinal asc) + ')) AS BINARY(32)) as ' as table_key
	from			source_view			sov
	where			sov.column_ordinal in (1, 2)
	group by		sov.objectMappingID
)
,					select_core			as
(
	select			gsc.ObjectMappingId
					,string_agg(gsc.select_line, ' ') within group (order by gsc.column_ordinal asc) as basic_select
	from			(select		det.ObjectMappingId
								,det.column_ordinal
								,case
									when det.column_ordinal in (2, 3) then ',CAST(HASHBYTES(''SHA2_256'',ISNULL(CAST('+ sov.column_name + ' AS NVARCHAR(100)),'''')) AS BINARY(32)) as ' + det.column_name
									when det.column_name = sov.column_name then ',' + det.column_name
									else ',' + sov.column_name + ' as ' + det.column_name
								end as select_line
					from		destination_table	det
					inner join	source_view			sov on sov.ObjectMappingId = det.ObjectMappingId and det.column_ordinal = sov.column_ordinal + 1
					) as gsc
	group by		gsc.ObjectMappingId
)
,					group_by_list		as
(
	select			det.ObjectMappingId
					,string_agg(det.column_name, ', ') within group (order by det.column_ordinal asc) as field_list
	from			destination_table det
	where			det.column_name <> 'ValidFrom'
	group by		det.ObjectMappingId
)


select				'Link' as 'TableType'
					,soc.ObjectMappingId
					,cast(concat('truncate table dv.',cast(soc.DestinationTable as varchar(8000)),'; insert into dv.',cast(soc.DestinationTable as varchar(8000)),' select ',cast(gro.field_list as varchar(8000)),' ,min(ValidFrom) as ValidFrom from (select ',cast(has.table_key as varchar(8000)),cast(kcc.key_column_name as varchar(8000)),cast(cor.basic_select as varchar(8000)),'	from adapt.',cast(soc.sourceTable as varchar(8000)),') as a group by ',cast(gro.field_list as varchar(8000)),';') as varchar(8000)) as rebuild_statement
from				source_config	soc
inner join			link_hash		has on has.ObjectMappingId = soc.ObjectMappingId
inner join			select_core		cor on cor.ObjectMappingId = soc.ObjectMappingId
inner join			group_by_list	gro on gro.ObjectMappingId = soc.ObjectMappingId
inner join			(select			det.ObjectMappingId
									,det.column_name as key_column_name
					 from			destination_table det
					 where			det.column_ordinal = 1) as kcc on kcc.ObjectMappingId = soc.ObjectMappingId
where				soc.DestinationTable is not null
and					gro.field_list is not null
and					has.table_key is not null
and					kcc.key_column_name is not null
and					cor.basic_select is not null
and					soc.sourceTable is not null
and					gro.field_list is not null;