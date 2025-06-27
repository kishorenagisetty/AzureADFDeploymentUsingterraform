CREATE PROC [ELT].[ProgrammesToRun_Load] AS

-- -------------------------------------------------------------------
-- Script:         ELT.ProgrammesToRun Load (for loading post deployment)
-- Target:         Azure Synapse Data Warehouse
-- -------------------------------------------------------------------
TRUNCATE TABLE [ELT].[ProgrammesToRun];

INSERT INTO [ELT].[ProgrammesToRun]
           ([ProgrammeID]
           ,[Programme]
           ,[Active]
           ,[RunOrder]
		   ,[batch])

	SELECT 
            [ProgrammeID]
           ,[Programme]
           ,[Active]
           ,[RunOrder]
		   ,[batch]
	FROM 
		[ext].[ELT_ProgrammesToRun];
