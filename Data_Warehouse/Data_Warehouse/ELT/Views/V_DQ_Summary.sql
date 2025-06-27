CREATE VIEW [ELT].[V_DQ_Summary]
AS SELECT 
 T.[Exception_Type]
,E.[Exception_Name]
,E.[DqExceptionID]
,E.[Impact]
,[Exception_Details]
,A.[Exception_Area]
,S.[DqExceptionSummaryID] AS SummaryID
,cast (S.DateTime AS DATE) DateTime 
, NumberOfExceptions

 FROM [ELT].[DQ_Exception_Summary] S
INNER  JOIN [ELT].[DQ_Exception] E ON (S.[DqExceptionID] = E.[DqExceptionID])
INNER  JOIN [ELT].[DQ_Exception_Type] T ON (E.[DqExceptionTypeID] = T.[DqExceptionTypeID])
INNER  JOIN [ELT].[DQ_Exception_Area] A ON (E.[DqExceptionAreaID] = A.[DqExceptionAreaID])
WHERE DateTime >= GETDATE() -30;