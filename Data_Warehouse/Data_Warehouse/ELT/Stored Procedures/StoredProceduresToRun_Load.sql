CREATE PROC [ELT].[StoredProceduresToRun_Load] @RunID [INT] AS

-- -------------------------------------------------------------------
-- Script:         ELT.StoredProceduresToRun Load (for loading post deployment)
-- Target:         Azure Synapse Data Warehouse
-- -------------------------------------------------------------------

BEGIN

BEGIN TRY   

SET @RunID = ISNULL(@RunID,0);
DECLARE @ActivityName VARCHAR(2000) = 'ELT.StoredProceduresToRun_Load'
DECLARE @Msg VARCHAR(2000) = 'Starting'
DECLARE @Datetime datetime = getdate()

EXEC [ELT].[sp_AuditProcess] @RunID ,@ActivityName ,@Datetime ,@Msg ,'I'

TRUNCATE TABLE [ELT].[StoredProceduresToRun];

INSERT INTO [ELT].[StoredProceduresToRun]
           ([Schema]
           ,[Name]
           ,[Stage]
           ,[Active]
           ,[RunOrder])

	SELECT 
           [Schema]
           ,[Name]
           ,[Stage]
           ,[Active]
           ,[RunOrder]
	FROM 
		[ext].[ELT_StoredProceduresToRun];

SET @Msg = 'Completed';
SET @Datetime = getdate();

EXEC [ELT].[sp_AuditProcess] @RunID, @ActivityName, @Datetime, @Msg ,'C'


END TRY 
 
	BEGIN CATCH  
		SET @Datetime = GETDATE();
		SET @Msg = 'Error ' + ERROR_MESSAGE();

		EXEC [ELT].[sp_AuditProcess] @RunID ,@ActivityName ,@Datetime ,@Msg ,'E';

		THROW ;
	
    
	END CATCH  

END
