CREATE PROC [ELT].[sp_AuditProcess] @RunID [INT],@ActivityName [VARCHAR](2000),@DateTime [datetime],@Msg [VARCHAR](2000),@Type [VARCHAR](1) AS

BEGIN
			  
	BEGIN TRANSACTION

		INSERT INTO	ELT.CTL_MsgLog (	[RunID],
										[ActivityName],
										[Datetime],
										[Msg],
										[Type]
									)
		SELECT	@RunID,
				@ActivityName,
				@DateTime,
				@Msg,
				@Type
	COMMIT TRANSACTION

END