CREATE PROC [LZ].[CustomerMasking] AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON

ALTER TABLE LZ.AtW_vw_cm_customer  
ALTER COLUMN urn varchar(255) MASKED WITH (FUNCTION = 'default()')

ALTER TABLE LZ.AtW_vw_cm_customer 
ALTER COLUMN individuallearnernumber varchar(255) MASKED WITH (FUNCTION = 'default()'); 

END