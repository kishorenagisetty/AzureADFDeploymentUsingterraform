CREATE VIEW [ICONI].[SAT_Participant_Iconi_Address] AS SELECT
CONCAT_WS('|','ICONI',P.individual_id) AS ParticipantKey,
P.ind_address1 AS AddressLine1,
P.ind_address2 AS AddressLine2,
P.ind_address3 AS Locality,
P.ind_town AS Town,
P.ind_county AS County,
P.ind_postcode AS PostCode,
P.ValidFrom AS ValidFrom,
P.ValidTo AS ValidTo,
P.IsCurrent AS IsCurrent
FROM ICONI.vBICommon_Individual as P;