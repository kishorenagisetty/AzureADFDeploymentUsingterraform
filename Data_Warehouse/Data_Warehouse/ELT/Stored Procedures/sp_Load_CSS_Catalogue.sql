CREATE PROC [ELT].[sp_Load_CSS_Catalogue]
AS
-- =======================================================================================================================================================
-- Author: Sagar Kadiyala
-- Create date: 11/09/2023
-- Ticket Reference:  #27410
-- Description: Load to CSS_Catalogue table
-- Revisions:
-- 11/09/2023 - SK - 27410 - Created the new SP to load the ELT.CSS_Catalogue from external table
-- =======================================================================================================================================================
BEGIN

    TRUNCATE TABLE [ELT].[CSS_Catalogue]

    INSERT INTO [ELT].[CSS_Catalogue]
    (
        [CSS_ContractRefNo],
        [ProgrammeName],
        [CSSName],
        [DWP_Description],
        [DWP_DueDate],
        [DWP_SuccessCriteria],
        [DWP_HowManyRecords],
        [DWP_HowManyRecordsExempt],
        [DWP_HowManyRecordsNotes],
        [CSS_SortOrder]
    )
    SELECT [CSS_ContractRefNo],
           [ProgrammeName],
           [CSSName],
           [DWP_Description],
           [DWP_DueDate],
           [DWP_SuccessCriteria],
           [DWP_HowManyRecords],
           [DWP_HowManyRecordsExempt],
           [DWP_HowManyRecordsNotes],
           [CSS_SortOrder]
    FROM [Ext].[CSS_Catalogue]


END
Go