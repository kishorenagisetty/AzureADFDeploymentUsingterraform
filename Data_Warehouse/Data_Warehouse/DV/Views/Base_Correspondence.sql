CREATE VIEW DV.Base_Correspondence AS 
SELECT * FROM DV.Base_Correspondence_Default
UNION ALL
SELECT * FROM DV.Base_Correspondence_Adapt;
GO