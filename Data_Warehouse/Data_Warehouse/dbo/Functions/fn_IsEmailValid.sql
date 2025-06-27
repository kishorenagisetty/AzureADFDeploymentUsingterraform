/****** Object:  UserDefinedFunction [dbo].[fn_IsEmailValid]    Script Date: 22/11/2023 16:37:47 ******/

CREATE FUNCTION [dbo].[fn_IsEmailValid] (@EMAIL [varchar](100)) RETURNS bit
AS
BEGIN  
     DECLARE @valid bit  

     IF @email IS NOT NULL   
          SET @email = LOWER(@email)  

     SET @valid = 0  

     IF @email LIKE '[a-z,0-9,_,+,-]%@[a-z,0-9,-]%.[a-z][a-z]%' 
        AND @email NOT like '%@%@%' 
        AND CHARINDEX('.@',@email) = 0
        AND PATINDEX('%[a-zA-Z]%', @email) <> 0
        AND CHARINDEX('..',@email) = 0  
        AND CHARINDEX(',',@email) = 0              
        AND RIGHT(@email,1) between 'a' AND 'z'  
            SET @valid = 1  

     RETURN @valid  
END
GO


