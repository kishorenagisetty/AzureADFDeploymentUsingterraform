CREATE PROC [ELT].[DQ_Alert_Load] AS

-- -------------------------------------------------------------------
-- Script:         ELT.DQ_Alert Load (for loading post deployment)
-- Target:         Azure Synapse Data Warehouse
-- -------------------------------------------------------------------

TRUNCATE TABLE [ELT].[DQ_Alert];

INSERT INTO [ELT].[DQ_Alert] (  [DqAlertID]
							  , [DqExceptionTypeID]
							  , [DqExceptionAreaID]
							  , [Importance]
							  , [Active]
							  , [AlertName]
							  , [AlertDetails]
							  , [EmailNotificationonFailure]
							  , [EmailFailureMessage]
							  , [EmailNotificationonFailureOK]
							  , [EmailFailureOKMessage]
							  , [EmailNotificationonSuccess]
							  , [EmailSuccessMessage]
							  , [EmailSubject]
							  , [RecipientsView]
							  , [CcRecipientsView]
							  , [BccRecipientsView]
							  , [AlertView]
							  )

	SELECT 
		        [DqAlertID]
			  , [DqExceptionTypeID]
			  , [DqExceptionAreaID]
			  , [Importance]
			  , [Active]
			  , [AlertName]
			  , [AlertDetails]
			  , [EmailNotificationonFailure]
			  , [EmailFailureMessage]
			  , [EmailNotificationonFailureOK]
			  , [EmailFailureOKMessage]
			  , [EmailNotificationonSuccess]
			  , [EmailSuccessMessage]
			  , [EmailSubject]
			  , [RecipientsView]
			  , [CcRecipientsView]
			  , [BccRecipientsView]
			  , [AlertView]
	FROM 
		[ext].[ELT_DQ_Alert];
