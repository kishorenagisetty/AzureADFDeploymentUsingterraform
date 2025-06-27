CREATE TABLE [DV].[SAT_WorkFlowEvents_Meta_Core_New] (
    [CaseHashBin]                     BINARY (32)  NOT NULL,
    [CaseHash]                        CHAR (66)    NOT NULL,
    [EmployeeHashBin]                 BINARY (32)  NULL,
    [EmployeeHash]                    CHAR (66)    NULL,
    [AssignmentHashIfNeeded]          CHAR (66)    NULL,
    [WorkFlowEventDate]               DATE         NULL,
    [WorkFlowEventEstimatedStartDate] DATE         NULL,
    [WorkFlowEventEstimatedEndDate]   DATE         NULL,
    [InOutWork]                       VARCHAR (10) NULL,
    [CSSName]                         VARCHAR (24) NOT NULL,
    [RecordSource]                    VARCHAR (24) NOT NULL
)
WITH (HEAP, DISTRIBUTION = HASH([CaseHashBin]));

