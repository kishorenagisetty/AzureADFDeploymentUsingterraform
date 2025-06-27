CREATE VIEW [ELT].[V_DQ_Detail]
AS SELECT 
 T.[Exception_Type]
,E.[Exception_Name]
,S.[DqExceptionSummaryID] AS SummaryID
,S.DateTime
,NumberOfExceptions
,D.[Msg]
,[DqExceptionDetailID]
 FROM [ELT].[DQ_Exception_Detail] D
INNER JOIN [ELT].[DQ_Exception_Summary] S ON (S.[DqExceptionSummaryID] = D.[DqExceptionSummaryID] )
INNER JOIN [ELT].[DQ_Exception] E ON (S.[DqExceptionID] = E.[DqExceptionID])
INNER JOIN [ELT].[DQ_Exception_Type] T ON (E.[DqExceptionTypeID] = T.[DqExceptionTypeID]);