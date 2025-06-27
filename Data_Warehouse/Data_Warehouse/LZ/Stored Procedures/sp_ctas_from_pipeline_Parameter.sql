CREATE PROC [LZ].[sp_ctas_from_pipeline_Parameter] @Source_Schema [varchar](255),@Dest_Schema [varchar](255),@Table_Name [varchar](255),@distribution_type [varchar](255) AS
BEGIN
 
--declare @TableName varchar(255)
declare @Table_Sink varchar(255)
declare @Table_Source varchar(255)
declare @sql varchar(max)
 
--set @table = @s
set @table_source = @Source_Schema + '.' + @Table_Name
set @table_sink = @Dest_Schema + '.' + @Table_Name
 
 
set @sql = 
'if object_id ('''+ @table_sink + ''',''U'') is not null drop table ' +@table_sink +';
 
CREATE TABLE ' + @table_sink + '
WITH
(
DISTRIBUTION = ' + @distribution_type + '
,CLUSTERED COLUMNSTORE INDEX
)
AS
SELECT  *
FROM    ' + @table_source + ';'
 
exec(@sql)
 
END
