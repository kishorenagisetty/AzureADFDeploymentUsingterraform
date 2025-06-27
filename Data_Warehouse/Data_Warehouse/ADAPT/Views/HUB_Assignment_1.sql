-- This is for testing by Sarath Koritala
CREATE VIEW [ADAPT].[HUB_Assignment] AS (
Select Distinct
	CONCAT_WS('|','ADAPT',ASSIG_ID)				AS AssignmentKey,
	'ADAPT.PROP_ASSIG_GEN'						AS RecordSource,
	ValidFrom									AS ValidFrom,
	ValidTo										AS ValidTo,
	IsCurrent									AS IsCurrent


from 
	ADAPT.PROP_ASSIG_GEN



	);
GO