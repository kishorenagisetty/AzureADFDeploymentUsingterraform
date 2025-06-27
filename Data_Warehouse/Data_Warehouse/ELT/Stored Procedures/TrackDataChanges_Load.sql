CREATE PROC [ELT].[TrackDataChanges_Load] AS

-- -------------------------------------------------------------------
-- Script:         ELT.TrackDataChanges Load (for loading post deployment)
-- Target:         Azure Synapse Data Warehouse
-- -------------------------------------------------------------------

TRUNCATE TABLE [ETL].[TrackDataChanges];

INSERT INTO [ETL].[TrackDataChanges]
           ([TrackDataChangesID]
		   ,[Source_Name]
		   ,[Source_Schema]
           ,[Stage_Schema]
           ,[Dest_Schema]
           ,[Table]
           ,[ID]
           ,[Key]
           ,[Enabled])

	SELECT 
			[TrackDataChangesID]
		   ,[Source_Name]
		   ,[Source_Schema]
           ,[Stage_Schema]
           ,[Dest_Schema]
           ,[Table]
           ,[ID]
           ,[Key]
           ,[Enabled]
	FROM 
		[ext].[ELT_TrackDataChanges];
