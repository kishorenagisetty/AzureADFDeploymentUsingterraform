CREATE PROC [DW].[D_Time_Load] AS

------ -------------------------------------------------------------------
------ Script:         DW.D_KPI Load (with version history)
------ Target:         Azure Synapse Data Warehouse
------ -------------------------------------------------------------------

------ Delete temporary tables if present.

if object_id ('stg.DW_D_Time_TEMP','U')  is not null drop table stg.DW_D_Time_TEMP;
if object_id ('stg.DW_D_Time_TEMP1','U') is not null drop table stg.DW_D_Time_TEMP1;
if object_id ('stg.DW_D_Time_TEMP2','U') is not null drop table stg.DW_D_Time_TEMP2;

-- -------------------------------------------------------------------
-- First TEMP table creates new versions of changing rows.
-- -------------------------------------------------------------------

-- Get dataset from Landing Zone
CREATE TABLE stg.DW_D_Time_TEMP
        WITH (clustered columnstore index, distribution = hash([Time])) 
AS

SELECT
	--CAST(row_number() over (order by getdate()) as int) -1 as [Time_Skey] ,
	[Time] ,
	[Hour] ,
	[MilitaryHour] ,
	[Minute] ,
	[Second] ,
	[AmPm] ,
	[StandardTime] ,
	[Time_Hour_Quarter],
	GETDATE() AS [Sys_LoadDate],
	GETDATE()  AS [Sys_ModifiedDate]
FROM [ext].[D_Time]
OPTION (LABEL = 'CTAS : Load [DW].[D_Time]')
;

-- Append new versions of changing rows
CREATE TABLE stg.DW_D_Time_TEMP1 
WITH (clustered columnstore index, distribution = hash([Time])) as

SELECT
	    dw.Time_Skey,
		stg.[Time] ,
		stg.[Hour] ,
		stg.[MilitaryHour] ,
		stg.[Minute] ,
		stg.[Second] ,
		stg.[AmPm] ,
		stg.[StandardTime] ,
		stg.[Time_Hour_Quarter],
		dw.[Sys_LoadDate],
		stg.[Sys_ModifiedDate]
FROM stg.DW_D_Time_TEMP stg
	INNER JOIN DW.D_Time DW
		ON DW.[Time] = stg.[Time]

-- -------------------------------------------------------------------
-- Second pass appends new rows to table
-- -------------------------------------------------------------------

-- Copy current table .. note distribution to REPLICATE

create  table stg.DW_D_Time_TEMP2
        with (clustered columnstore index, distribution = replicate) as
select
	-1 AS Time_Skey,
	CAST('00:00:00.0000001' AS Time)	AS [Time],
	'Unknown'					AS [Hour],
	'Unknown'					AS [MilitaryHour],
	'Unknown'					AS [Minute],
	'Unknown'					AS [Second],
	'Unknown'					AS [AmPm],
	'Unknown'					AS [StandardTime],
	'Unknown'					AS [Time_Hour_Quarter],
	'1900-1-1'					AS Sys_LoadDate,
    '1900-1-1'					AS Sys_ModifiedDate

UNION

select
	    stg.Time_Skey,
		stg.[Time] ,
		stg.[Hour] ,
		stg.[MilitaryHour] ,
		stg.[Minute] ,
		stg.[Second] ,
		stg.[AmPm] ,
		stg.[StandardTime] ,
		stg.[Time_Hour_Quarter],
		stg.[Sys_LoadDate],
		stg.[Sys_ModifiedDate]
FROM    stg.DW_D_Time_TEMP1 stg

UNION ALL
-- Add new rows.
select	cast(COALESCE((select max(Time_SKey) from stg.DW_D_Time_TEMP1),0) + row_number() over (order by getdate()) as int) as Time_Skey,
		stg.[Time] ,
		stg.[Hour] ,
		stg.[MilitaryHour] ,
		stg.[Minute] ,
		stg.[Second] ,
		stg.[AmPm] ,
		stg.[StandardTime] ,
		stg.[Time_Hour_Quarter],
		stg.[Sys_LoadDate],
		stg.[Sys_ModifiedDate]
from    stg.DW_D_Time_TEMP stg
        left outer join stg.DW_D_Time_TEMP1 stg_t1
        on stg_t1.[Time] = stg.[Time]
where   stg_t1.[Time] is null

-- Create NOT NULL constraint on temp
alter table stg.DW_D_Time_TEMP2
ALTER COLUMN Time_SKey INT NOT NULL

-- Create primary key on temp
alter table stg.DW_D_Time_TEMP2
ADD CONSTRAINT PK_DW_D_Time PRIMARY KEY NONCLUSTERED (Time_SKey) NOT ENFORCED

-- Switch table contents replacing target with temp.

alter table DW.D_Time switch to OLD.DW_D_Time with (truncate_target=on);
alter table stg.DW_D_Time_TEMP2 switch to DW.D_Time with (truncate_target=on);

drop table stg.DW_D_Time_TEMP;
drop table stg.DW_D_Time_TEMP1;
drop table stg.DW_D_Time_TEMP2;

-- Force replication of table.
--select  * from DW.D_Time order by Time_Skey;