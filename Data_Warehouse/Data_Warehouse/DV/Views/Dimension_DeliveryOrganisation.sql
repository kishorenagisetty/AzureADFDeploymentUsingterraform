CREATE VIEW [DV].[Dimension_DeliveryOrganisation]
AS SELECT 

			 [DeliveryOrganisationHash]
			,[RecordSource]
			,[AgencyContactDetailsId]
			,[AgencyName]
			,[AgencyShortName]
			,[AgencyProvideService]
			,[AgencyAddedDate]
			,[AgencyNotes]
			,[AgencyType]
			,[AgencyLastUpdatedDate]

			FROM (
				SELECT
						 [DeliveryOrganisationHash]
						,row_number() OVER (PARTITION BY [DeliveryOrganisationHash] ORDER BY [DeliveryOrganisationHash]) rn
						,[RecordSource]
						,[AgencyContactDetailsId]
						,[AgencyName]
						,[AgencyShortName]
						,[AgencyProvideService]
						,[AgencyAddedDate]
						,[AgencyNotes]
						,[AgencyType]
						,[AgencyLastUpdatedDate]

						FROM [DV].[Base_DeliveryOrganisation]
						) src
				WHERE (rn = 1);