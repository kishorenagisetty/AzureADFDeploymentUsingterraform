CREATE PROC [DW].[D_Candidate_Load] AS


-- -------------------------------------------------------------------
-- Script:         DW.D_Candidate Load
-- Target:         Azure Synapse Data Warehouse
-- -------------------------------------------------------------------

-- Delete temporary tables if present.

if object_id ('stg.DW_D_Candidate_TEMP','U') is not null drop table stg.DW_D_Candidate_TEMP;
if object_id ('stg.DW_D_Candidate_TEMP1','U') is not null drop table stg.DW_D_Candidate_TEMP1;
if object_id ('stg.DW_D_Candidate_TEMP2','U') is not null drop table stg.DW_D_Candidate_TEMP2;

-- -------------------------------------------------------------------
-- First pass creates new versions of changing rows.
-- -------------------------------------------------------------------

-- Get dataset from Landing Zone
CREATE TABLE stg.DW_D_Candidate_TEMP
        with (clustered columnstore index, distribution = hash(CandidateBusKey))
AS

SELECT 
       [cust].[CustomerID] AS CandidateBusKey
	  ,[cust].[CustomerReferenceKey] AS CustomerReferenceID
      ,COALESCE(NULLIF([title].[Title],'') , 'Not Set') AS Title
      ,COALESCE(NULLIF([cust].[PostCode_Sector],''),'Not Set') AS PostcodeSector
      ,COALESCE(NULLIF([cnty].[County],''),'Not Set')		as County
      ,COALESCE(NULLIF([rgn].[Region],''),'Not Set')		AS Region
      ,COALESCE(NULLIF([cust].[UniqueReferenceNumber],''),'Not Set')			AS UniqueReferenceNumber
      ,COALESCE(NULLIF([cust].[IndividualLearnerNumber],''),'Not Set') AS IndividualLearnerNumber
      ,COALESCE(NULLIF([cm].[ContactMethod],''),'Not Set') AS ContactMethod
      ,[cust].[Sys_LoadDate]
      ,[cust].[Sys_LoadExpiryDate]
      ,[cust].[Sys_IsCurrent]
      ,[cust].[Sys_RunID]
  FROM [DS].[Customer] cust
	LEFT JOIN [DS].[Title] title ON title.TitleID = cust.TitleID
	LEFT JOIN [DS].[County] cnty ON cnty.CountyID = cust.CountyID
	LEFT JOIN [DS].[Region] rgn ON rgn.RegionID = cust.RegionID
	LEFT JOIN [DS].[Contact_Method] cm ON cm.ContactMethodID = cust.ContactMethodID

-- Update Existing Rows
CREATE TABLE stg.DW_D_Candidate_TEMP1
        with (clustered columnstore index, distribution = hash(CandidateBusKey))
AS

SELECT DW.Candidate_Skey
      ,stg.CandidateBusKey
	  ,stg.CustomerReferenceID
      ,stg.Title
      ,stg.PostcodeSector
      ,stg.County
      ,stg.Region
      ,stg.UniqueReferenceNumber
      ,stg.IndividualLearnerNumber
      ,stg.ContactMethod
      ,stg.[Sys_LoadDate]
      ,stg.[Sys_LoadExpiryDate]
      ,stg.[Sys_IsCurrent]
      ,stg.[Sys_RunID]
FROM stg.DW_D_Candidate_TEMP stg
	INNER JOIN DW.[D_Candidate] DW
		ON DW.CandidateBusKey = stg.CandidateBusKey

-- -------------------------------------------------------------------
-- Second pass appends new rows to table
-- -------------------------------------------------------------------

-- Copy current table .. note distribution to REPLICATE

create  table stg.DW_D_Candidate_TEMP2
        with (clustered columnstore index, distribution = replicate) as

SELECT
	     -1					AS Candidate_Skey
	    ,-1					AS CandidateBusKey
	    ,0					AS CustomerReferenceID
		,'Not Available'	AS Title
		,'Not Available'	AS PostcodeSector
		,'Not Available'	AS County
		,'Not Available'	AS Region
		,'Not Available'	AS UniqueReferenceNumber
		,'Not Available'	AS IndividualLearnerNumber
		,'Not Available'	AS ContactMethod
		,'1900-1-1'			AS Sys_LoadDate
		,'9999-12-31' AS Sys_LoadExpiryDate
		,CAST(1 AS BIT) AS Sys_IsCurrent	
		,-1					AS Sys_RunID		

UNION ALL

SELECT stg.Candidate_Skey
      ,stg.CandidateBusKey
	  ,stg.CustomerReferenceID
      ,stg.Title
      ,stg.PostcodeSector
      ,stg.County
      ,stg.Region
      ,stg.UniqueReferenceNumber
      ,stg.IndividualLearnerNumber
      ,stg.ContactMethod
      ,stg.[Sys_LoadDate]
      ,stg.[Sys_LoadExpiryDate]
      ,stg.[Sys_IsCurrent]
      ,stg.[Sys_RunID]
FROM stg.DW_D_Candidate_TEMP1 stg

UNION ALL

SELECT cast(COALESCE((select max(Candidate_Skey) from stg.DW_D_Candidate_TEMP1),0) + row_number() over (order by getdate()) as int) AS Candidate_Skey
      ,stg.CandidateBusKey
	  ,stg.CustomerReferenceID
      ,stg.Title
      ,stg.PostcodeSector
      ,stg.County
      ,stg.Region
      ,stg.UniqueReferenceNumber
      ,stg.IndividualLearnerNumber
      ,stg.ContactMethod
      ,stg.[Sys_LoadDate]
      ,stg.[Sys_LoadExpiryDate]
      ,stg.[Sys_IsCurrent]
      ,stg.[Sys_RunID]
FROM stg.DW_D_Candidate_TEMP stg
        left outer join stg.DW_D_Candidate_TEMP1 stg_t1
        on stg_t1.CandidateBusKey = stg.CandidateBusKey
where   stg_t1.CandidateBusKey is null

-- Create NOT NULL constraint on temp
alter table stg.DW_D_Candidate_TEMP2
ALTER COLUMN Candidate_Skey INT NOT NULL

-- Create primary key on temp
alter table stg.DW_D_Candidate_TEMP2
ADD CONSTRAINT PK_DW_Candidate PRIMARY KEY NONCLUSTERED (Candidate_Skey) NOT ENFORCED

-- Switch table contents replacing target with temp.

alter table DW.[D_Candidate] switch to OLD.DW_D_Candidate with (truncate_target=on);
alter table stg.DW_D_Candidate_TEMP2 switch to DW.[D_Candidate] with (truncate_target=on);

drop table stg.DW_D_Candidate_TEMP;
drop table stg.DW_D_Candidate_TEMP1;
drop table stg.DW_D_Candidate_TEMP2;

-- Force replication of table.

--select  * from DW.[D_Candidate] order by 1;
