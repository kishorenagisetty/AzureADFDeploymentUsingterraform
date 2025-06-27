CREATE PROC [ELT].[UnProcessedEmails] AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON

SELECT * 
FROM ELT.CTL_Email_Log 
WHERE IsProcessed = 'N'
ORDER BY RequestCreatedOn ASC

END