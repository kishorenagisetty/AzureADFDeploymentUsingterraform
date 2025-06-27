CREATE PROC [ELT].[DQ_Exception_Type_Load] AS

-- -------------------------------------------------------------------
-- Script:         ELT.DQ_Exception_Type Load (for loading post deployment)
-- Target:         Azure Synapse Data Warehouse
-- -------------------------------------------------------------------

TRUNCATE TABLE [ELT].[DQ_Exception_Type];

INSERT INTO [ELT].[DQ_Exception_Type] ([DqExceptionTypeID] , [Exception_Type])

	SELECT 
	   [DqExceptionTypeID]
      ,[Exception_Type]
	FROM 
		[ext].[ELT_DQ_Exception_Type];
