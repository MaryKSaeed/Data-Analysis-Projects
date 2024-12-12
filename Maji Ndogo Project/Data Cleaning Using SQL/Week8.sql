USE md_water_services;


DROP TABLE IF EXISTS `auditor_report`;
CREATE TABLE `auditor_report` (
`location_id` VARCHAR(32),
`type_of_water_source` VARCHAR(64),
`true_water_source_score` int DEFAULT NULL,
`statements` VARCHAR(255)
);





WITH
Comparison_Report AS(
SELECT auditor_report.true_water_source_score AS auditor_score,
water_quality.subjective_quality_score AS survyor_score,
auditor_report.location_id AS Location_id,
(auditor_report.true_water_source_score - water_quality.subjective_quality_score) AS DIFFERENCE,
water_quality.record_id AS record_id,
employee.employee_name AS employee_name
FROM auditor_report, visits, water_quality, employee
WHERE auditor_report.location_id = visits.location_id
AND visits.record_id = water_quality.record_id
AND visits.assigned_employee_id = employee.assigned_employee_id
AND visits.visit_count = 1
AND auditor_report.true_water_source_score - water_quality.subjective_quality_score <> 0
),
error_count AS(
SELECT
employee_name,
COUNT(employee_name) AS number_of_mistakes
FROM Comparison_Report
GROUP BY employee_name
)

SELECT
employee_name,
number_of_mistakes
FROM
error_count
WHERE
number_of_mistakes > 6;


-- Create view
CREATE VIEW Incorrect_records AS (
SELECT
auditor_report.location_id,
visits.record_id,
employee.employee_name,
auditor_report.true_water_source_score AS auditor_score,
wq.subjective_quality_score AS surveyor_score,
auditor_report.statements AS statements
FROM
auditor_report
JOIN
visits
ON auditor_report.location_id = visits.location_id
JOIN
water_quality AS wq
ON visits.record_id = wq.record_id
JOIN
employee
ON employee.assigned_employee_id = visits.assigned_employee_id
WHERE
visits.visit_count =1
AND auditor_report.true_water_source_score != wq.subjective_quality_score);

SELECT * FROM Incorrect_records;


-- Making the employee mistakes analysis into a CTE
WITH error_count AS ( -- This CTE calculates the number of mistakes each employee made
SELECT
employee_name,
COUNT(employee_name) AS number_of_mistakes
FROM
Incorrect_records
/* Incorrect_records is a view that joins the audit report to the database
for records where the auditor and employees scores are different */
GROUP BY
employee_name)
-- Query
SELECT * FROM error_count;

-- Analysis on fishy behavior by some employees
SELECT 
employee.employee_name AS employee_name,
auditor_report.statements AS statements,
auditor_report.location_id AS location_id
FROM auditor_report, employee, visits
WHERE auditor_report.location_id = visits.location_id
AND employee.assigned_employee_id = visits.assigned_employee_id
AND employee.employee_name IN ('Bello Azibo','Zuriel Matembo','Malachi Mavuso','Lalitha Kaburi')
AND auditor_report.statements LIKE '%cash%' ;

-- 'Bello Azibo' , 'Lalitha Kaburi' , 'Malachi Mavuso' , 'Bello Azibo'