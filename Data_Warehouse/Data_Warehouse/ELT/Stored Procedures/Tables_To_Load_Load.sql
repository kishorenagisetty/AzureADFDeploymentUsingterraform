CREATE PROC [ELT].[Tables_To_Load_Load] AS

-- -------------------------------------------------------------------
-- Script:         ELT.Tables_To_Load Load (for loading post deployment)
-- Target:         Azure Synapse Data Warehouse
-- -------------------------------------------------------------------

TRUNCATE TABLE [ETL].[Tables_To_Load];

INSERT INTO [ETL].[Tables_To_Load]
           ([Source_Name]
           ,[Source_Schema]
           ,[Source_Table]
           ,[Dest_Schema]
           ,[Dest_table]
           ,[Columns]
           ,[WatermarkColumn]
           ,[WatermarkValue]
           ,[Enabled]
           ,[Distribution_Type]
           ,[ObjectType]
           ,[Dest_Table_Prefix])

	SELECT 
			[Source_Name]
           ,[Source_Schema]
           ,[Source_Table]
           ,[Dest_Schema]
           ,[Dest_table]
           ,[Columns]
           ,[WatermarkColumn]
           ,[WatermarkValue]
           ,[Enabled]
           ,[Distribution_Type]
           ,[ObjectType]
           ,[Dest_Table_Prefix]
	FROM 
		[ext].[ELT_Tables_To_Load];
