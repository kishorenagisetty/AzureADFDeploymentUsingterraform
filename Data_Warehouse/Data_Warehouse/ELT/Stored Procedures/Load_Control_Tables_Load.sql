CREATE PROC [ELT].[Load_Control_Tables_Load] AS

-- -------------------------------------------------------------------
-- Script:         ELT.Load_Control_Tables Load (for loading post deployment)
-- Target:         Azure Synapse Data Warehouse
-- -------------------------------------------------------------------

TRUNCATE TABLE [ELT].[Load_Control_Table];

INSERT INTO [ELT].[Load_Control_Table] ([TableName] , [Load_Date])

	SELECT 
	   [TableName]
     , [Load_Date]
	FROM 
		[ext].[ELT_Load_Control_Table];

UPDATE ELT.Load_Control_Table SET Load_Date = CAST(DATEADD(d,-7,GETDATE()) AS DATE) WHERE TableName = 'DW.F_AtW_Case_Daily_Analysis';
