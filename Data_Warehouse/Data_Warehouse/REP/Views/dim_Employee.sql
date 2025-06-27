CREATE VIEW [REP].[dim_Employee]
AS
-- ===============================================================
-- Author:	Sagar Kadiyala
-- Create date: 31/01/2024
-- Ticket Ref: #30330
-- Name: [REP].[dim_Employee] 
-- Description: Dimension Table
-- Revisions:
-- 30330 - SK - 31/01/2024 - Created a Dimension View for Employees / Advisors
-- ===============================================================
SELECT CONVERT(char(66), he.EmployeeHash  , 1)                     AS EmployeeHash
     , REPLACE(CAST(sei.EmployeeKey AS VARCHAR(25)), 'ICONI|', '') AS EmployeeKey
     , sei.EmployeeFirstName                                       AS EmployeeFirstName
     , sei.EmployeeLastName                                        AS EmployeeLastName
     , sei.EmployeeFullName                                        AS EmployeeFullName
     , sei.EmployeeEmail                                           AS EmployeeEmail
     , sei.EmployeeUserName                                        AS EmployeeUserName
FROM DV.HUB_Employee                he
    JOIN DV.SAT_Employee_Iconi_Core sei
        ON he.EmployeeHash = sei.EmployeeHash
WHERE sei.IsCurrent = 1
      AND he.recordSource = 'ICONI.User';
Go
