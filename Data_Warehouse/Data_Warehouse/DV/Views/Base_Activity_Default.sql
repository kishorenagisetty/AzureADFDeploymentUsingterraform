CREATE VIEW [DV].[Base_Activity_Default] AS SELECT
CONVERT(CHAR(66),CAST(0x0 AS BINARY(32)),1) AS ActivityHash,
CAST('Unknown' AS NVARCHAR(MAX)) AS RecordSource,
CAST('Unknown' AS NVARCHAR(MAX)) AS ActivityID,
CAST('Unknown' AS NVARCHAR(MAX)) AS ContactMethod,
CAST('Unknown' AS NVARCHAR(MAX)) AS ActivityName,
CAST('Unknown' AS NVARCHAR(MAX)) AS ActivityOtherEmployee,
CAST('Unknown' AS NVARCHAR(MAX)) AS ActivityLocation,
CAST('Unknown' AS NVARCHAR(MAX)) AS ActivityLevel,
CAST('Unknown' AS NVARCHAR(MAX)) AS AttendanceReasonOther,
CAST('Unknown' AS NVARCHAR(MAX)) AS ActivityRelatedSupportNeed,
CAST('Unknown' AS NVARCHAR(MAX)) AS ActivityRelatedAssignment,
CAST('Unknown' AS NVARCHAR(MAX)) AS ActivityDescription,
CAST('Unknown' AS NVARCHAR(MAX)) AS ActivityOutcome,
CAST('Unknown' AS NVARCHAR(MAX)) AS ActivityVenue;
GO

