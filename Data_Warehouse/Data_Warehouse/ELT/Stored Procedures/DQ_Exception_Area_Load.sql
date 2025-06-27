CREATE PROC [ELT].[DQ_Exception_Area_Load] AS

-- -------------------------------------------------------------------
-- Script:         ELT.DQ_Exception_Area Load (for loading post deployment)
-- Target:         Azure Synapse Data Warehouse
-- -------------------------------------------------------------------

TRUNCATE TABLE [ELT].[DQ_Exception_Area];

INSERT INTO [ELT].[DQ_Exception_Area] ([DqExceptionAreaID] , [Exception_Area])

	SELECT 
	   [DqExceptionAreaID]
      ,[Exception_Area]
	FROM 
		[ext].[ELT_DQ_Exception_Area];
