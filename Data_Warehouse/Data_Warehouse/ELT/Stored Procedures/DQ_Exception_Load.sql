CREATE PROC [ELT].[DQ_Exception_Load] AS

-- -------------------------------------------------------------------
-- Script:         ELT.DQ_Exception Load (for loading post deployment)
-- Target:         Azure Synapse Data Warehouse
-- -------------------------------------------------------------------

TRUNCATE TABLE [ELT].[DQ_Exception];

INSERT INTO [ELT].[DQ_Exception] (  [DqExceptionID]	,	[DqExceptionTypeID] ,	[DqExceptionAreaID] ,	[Impact] ,	[AdHoc]	,	[Active] ,	[Exception_Name] ,	[Exception_Details])

	SELECT 
		    [DqExceptionID]
		,	[DqExceptionTypeID] 
		,	[DqExceptionAreaID] 
		,	[Impact] 
		,	[AdHoc]
		,	[Active] 
		,	[Exception_Name] 
		,	[Exception_Details]
	FROM 
		[ext].[ELT_DQ_Exception];
