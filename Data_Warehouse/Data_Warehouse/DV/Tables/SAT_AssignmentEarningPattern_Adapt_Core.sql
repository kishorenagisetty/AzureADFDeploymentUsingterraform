CREATE TABLE [DV].[SAT_AssignmentEarningPattern_Adapt_Core] (
    [AssignmentEarningPatternHash] BINARY (32)     NULL,
    [AssignmentEarningPatternKey]  NVARCHAR (100)  NULL,
    [RecordSource]                 VARCHAR (23)    NOT NULL,
    [EffectTo]                     DATETIME2 (0)   NULL,
    [Reference]                    DECIMAL (16)    NULL,
    [Monday]                       DECIMAL (4, 2)  NULL,
    [Tuesday]                      DECIMAL (4, 2)  NULL,
    [Wednesday]                    DECIMAL (4, 2)  NULL,
    [Thursday]                     DECIMAL (4, 2)  NULL,
    [Friday]                       DECIMAL (4, 2)  NULL,
    [Saturday]                    DECIMAL (4, 2)  NULL,
    [Sunday]                       DECIMAL (4, 2)  NULL,
    [WeeklyHours]                  NUMERIC (5, 2)  NULL,
    [EffectFrom]                   DATETIME2 (0)   NULL,
    [HourlyRate]                   DECIMAL (11, 2) NULL,
    [Status]                       DECIMAL (20)    NULL,
    [DateChanged]                  DATETIME2 (0)   NULL,
    [ContentHash]                  BINARY (32)     NULL,
    [ValidFrom]                    DATETIME2 (0)   NULL,
    [ValidTo]                      DATETIME2 (0)   NULL,
    [IsCurrent]                    BIT             NULL
)
WITH (HEAP, DISTRIBUTION = HASH([AssignmentEarningPatternHash]));

