CREATE PROC [ELT].[UpdateEmailLogProcessed] @EmailLogID [int] AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON

UPDATE ELT.CTL_Email_Log 
SET IsProcessed = 'Y' 
, EmailSentOn = GETDATE() 
WHERE EmailLogID = @EmailLogID

END