CREATE VIEW [ICONI].[SAT_Provider_Iconi_Core]
AS SELECT
CONCAT_WS('|','ICONI',A.agency_id) AS ProviderKey,
A.agency_admin_contact_details_id AS AgencyContactDetailsId,
A.agency_name AS AgencyName,
A.agency_short_name AS AgencyShortName,
A.agency_provide_service AS AgencyProvideService,
A.agency_added_date AS AgencyAddedDate,
A.agency_notes AS AgencyNotes,
A.agency_type AS AgencyType,
A.agency_last_updated_date AS AgencyLastUpdatedDate,
A.ValidFrom AS ValidFrom,
A.ValidTo AS ValidTo,
A.IsCurrent AS IsCurrent
FROM ICONI.vBICommon_Agency as A;