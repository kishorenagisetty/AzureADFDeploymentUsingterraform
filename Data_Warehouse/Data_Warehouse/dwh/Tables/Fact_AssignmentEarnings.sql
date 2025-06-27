CREATE TABLE [dwh].[Fact_AssignmentEarnings] (
    [Casehash]             CHAR (66) NULL,
    [ProjectedOutcomeDate] INT       NULL
)
WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN);

