CREATE PROC [DW].[D_Rota_Type_Load] AS

-- -------------------------------------------------------------------
-- Script:         DW.D_Rota_Type Load (no history)
-- Target:         Azure Synapse Data Warehouse
-- -------------------------------------------------------------------

-- Delete temporary tables if present.

if object_id ('stg.DW_D_Rota_Type_TEMP','U') is not null  drop table stg.DW_D_Rota_Type_TEMP;
if object_id ('stg.DW_D_Rota_Type_TEMP1','U') is not null drop table stg.DW_D_Rota_Type_TEMP1;
if object_id ('stg.DW_D_Rota_Type_TEMP2','U') is not null drop table stg.DW_D_Rota_Type_TEMP2;

-- -------------------------------------------------------------------
-- First pass creates new versions of changing rows.
-- -------------------------------------------------------------------

-- Get dataset from Landing Zone
CREATE TABLE stg.DW_D_Rota_Type_TEMP
        WITH (clustered columnstore index, distribution = hash(RotaTypeBusKey)) 
AS
SELECT
	DS.RotaTypeID AS RotaTypeBusKey,
	DS.RotaType,
	DS.[Description],
	DS.[Productive],
	[Sys_LoadDate],
    [Sys_ModifiedDate],
    [Sys_RunID]
FROM DS.Rota_Type DS

-- Update Existing Rows
CREATE TABLE stg.DW_D_Rota_Type_TEMP1
        WITH (clustered columnstore index, distribution = hash(RotaTypeBusKey)) as

SELECT
	DW.RotaType_Skey,
	stg.RotaTypeBusKey,
	stg.RotaType,
	stg.[Description],
	stg.[Productive],
	stg.Sys_LoadDate,
	stg.Sys_ModifiedDate,	
	stg.Sys_RunID
FROM stg.DW_D_Rota_Type_TEMP stg
	INNER JOIN DW.D_Rota_Type DW
		ON DW.RotaTypeBusKey = stg.RotaTypeBusKey

-- -------------------------------------------------------------------
-- Second pass appends new rows to table
-- -------------------------------------------------------------------

-- Copy current table .. note distribution to REPLICATE

create  table stg.DW_D_Rota_Type_TEMP2
        with (clustered columnstore index, distribution = replicate) as
SELECT
	   -1 AS RotaType_Skey,
	   -1 AS RotaTypeBusKey,
		'Not Available' AS RotaType,
		'Not Available' AS [Description],
		'Not Available' AS [Productive],
		'1900-1-1' AS Sys_LoadDate,
		'1900-1-1' AS Sys_ModifiedDate,
		-1 AS Sys_RunID		

UNION ALL

select	stg.RotaType_Skey,
		stg.RotaTypeBusKey,
		stg.RotaType,
		stg.[Description],
		stg.[Productive],
		stg.Sys_LoadDate,
		stg.Sys_ModifiedDate,	
		stg.Sys_RunID
FROM    stg.DW_D_Rota_Type_TEMP1 stg

UNION ALL
-- Add new rows.
select		cast(COALESCE((select max(RotaType_Skey) from stg.DW_D_Rota_Type_TEMP1),0) + row_number() over (order by getdate()) as int) as RotaType_Skey,
			stg.RotaTypeBusKey,
			stg.RotaType,
			stg.[Description],
			stg.[Productive],
			stg.Sys_LoadDate,
			stg.Sys_ModifiedDate,	
			stg.Sys_RunID
from    stg.DW_D_Rota_Type_TEMP stg
        left outer join stg.DW_D_Rota_Type_TEMP1 stg_t1
        on stg_t1.RotaTypeBusKey = stg.RotaTypeBusKey
where   stg_t1.RotaTypeBusKey is null

-- Create NOT NULL constraint on temp
alter table stg.DW_D_Rota_Type_TEMP2
ALTER COLUMN RotaType_Skey INT NOT NULL

-- Create primary key on temp
alter table stg.DW_D_Rota_Type_TEMP2
ADD CONSTRAINT PK_DW_D_RotaType PRIMARY KEY NONCLUSTERED (RotaType_Skey) NOT ENFORCED

-- Switch table contents replacing target with temp.

alter table DW.D_Rota_Type switch to OLD.DW_D_Rota_Type with (truncate_target=on);
alter table stg.DW_D_Rota_Type_TEMP2 switch to DW.D_Rota_Type with (truncate_target=on);

drop table stg.DW_D_Rota_Type_TEMP;
drop table stg.DW_D_Rota_Type_TEMP1;
drop table stg.DW_D_Rota_Type_TEMP2;

-- Force replication of table.

--select  * from DW.D_Rota_Type order by RotaType_Skey;

--drop table DW.D_Rota_Type
--drop table OLD.DW_D_Rota_Type

--CREATE TABLE DW.D_Rota_Type
--        WITH (clustered columnstore index, distribution = REPLICATE) 
--AS
--select a.* from stg.DW_D_Rota_Type_TEMP2 a WHERE 1=0

--CREATE TABLE OLD.DW_D_Rota_Type
--        WITH (clustered columnstore index, distribution = REPLICATE) 
--AS
--select a.* from stg.DW_D_Rota_Type_TEMP2 a WHERE 1=0