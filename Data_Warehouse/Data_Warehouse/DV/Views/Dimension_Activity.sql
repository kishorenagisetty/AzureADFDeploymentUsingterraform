CREATE VIEW [DV].[Dimension_Activity] AS SELECT
[ActivityHash],
[RecordSource],
[ActivityID],
[ContactMethod],
[ActivityName],
[ActivityOtherEmployee],
[ActivityLocation],
[ActivityLevel],
[AttendanceReasonOther],
[ActivityRelatedAssignment],
[ActivityDescription],
[ActivityOutcome],
[ActivityVenue]

FROM (

		SELECT
		[ActivityHash],
		row_number() OVER (PARTITION BY [ActivityHash] ORDER BY [ActivityHash]) rn,
		[RecordSource],
		[ActivityID],
		[ContactMethod],
		[ActivityName],
		[ActivityOtherEmployee],
		[ActivityLocation],
		[ActivityLevel],
		[AttendanceReasonOther],
		[ActivityRelatedAssignment],
		[ActivityDescription],
		[ActivityOutcome],
		[ActivityVenue]
		FROM [DV].[Base_Activity]
		) src
WHERE (rn = 1);
GO

