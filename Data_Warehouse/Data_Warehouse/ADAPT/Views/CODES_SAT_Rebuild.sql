CREATE VIEW [ADAPT].[CODES_SAT_Rebuild] AS with				source_config as 
(
	select			map.ObjectMappingID
					,map.SourceTable
					,map.DestinationTable
	from			elt.DVObjectMapping map
	where			map.SourceSchema = 'ADAPT'
	and				map.IsEnabled = 1
	and				substring(map.SourceTable, 1, 4) = 'SAT_'
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
	inner join		source_config		sco on sco.SourceTable = tab.name 
	where			col.name not in ('ValidFrom', 'ValidTo', 'IsCurrent') 
	and				schema_name(tab.[schema_id]) = 'ADAPT'
)
,					hashFieldList as
(
	select			svi.ObjectMappingId
					,',cast(HASHBYTES(''SHA2_256'',CONCAT_WS(''|'','''',' +
						string_agg(concat('ISNULL(CAST(',QUOTENAME(svi.column_name),' AS NVARCHAR(MAX)),'''')'),', ') WITHIN GROUP (ORDER BY svi.column_name ASC ) +
						')) AS BINARY(32)) as ContentHash' as hashFields
	from			source_view svi
	where			svi.column_ordinal > 1
	group by		svi.ObjectMappingId
)
,					source_select as
(
	select			det.ObjectMappingId	as ObjectMappingId
					,det.table_name		as destination_table
					,nss.table_name		as source_view
					,det.column_ordinal	as column_ordinal
					,det.column_name	as destination_column_name
					,nss.column_name		as source_column_name
					,case
						when det.column_ordinal = 1 then 'CAST(HASHBYTES(''SHA2_256'', ISNULL(CAST(' + nss.column_name + ' AS NVARCHAR(100)),'''')) AS BINARY(32)) AS ' + det.column_name
						when nss.column_name = det.column_name then ',' +  det.column_name
						else ',' + nss.column_name + ' as ' + det.column_name
					 end as select_line
	from			destination_table	det
	left outer join	(select		so1.ObjectMappingId
								,so1.table_name
								,so1.column_name
								,so1.column_ordinal
					from		source_view	so1
					where		so1.column_ordinal = 1
					union all
					select		so2.ObjectMappingId
								,so2.table_name
								,so2.column_name
								,so2.column_ordinal + 1
					from		source_view	so2
					) nss	on nss.ObjectMappingId = det.ObjectMappingId and nss.column_ordinal = det.column_ordinal
)
,					core_select as
(
	select			sos.ObjectMappingId
					,string_agg(sos.select_line, ' ') within group (order by sos.column_ordinal asc ) as select_line
	from			source_select	sos
	where			sos.select_line is not null
	group by		sos.ObjectMappingId
)


select				'Sat' as 'TableType'
					,scc.ObjectMappingId
					,cast(concat('truncate table dv.',cast(scc.DestinationTable as varchar(8000)),'; insert into dv.',cast(scc.DestinationTable as varchar(8000)),' select ',cast(css.select_line as varchar(8000)),cast(hfl.hashFields as varchar(8000)),',ValidFrom, ValidTo, IsCurrent from ADAPT.',cast(scc.SourceTable as varchar(8000)),';') as varchar(8000)) as rebuild_statement
from				source_config		 scc
left outer join		core_select			 css on	css.ObjectMappingId = scc.ObjectMappingId
left outer join		hashFieldList		 hfl on	hfl.ObjectMappingId = scc.ObjectMappingId
where				scc.DestinationTable is not null 
and					css.select_line		 is not null
and					hfl.hashFields		 is not null 
and					scc.SourceTable		 is not null;