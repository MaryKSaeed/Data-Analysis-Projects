

-- First we explore our database
SHOW TABLES;


-- Second we limit the types of water sources that the dataset has.
SELECT DISTINCT type_of_water_source
FROM md_water_services.water_source;


-- Third we access the visits table and see which water sources people wait for 8 hours in average to get water from.
SELECT *
FROM md_water_services.visits
WHERE time_in_queue>500;

/* ('SoRu35083224','SoKo33124224','KiRu26095224','SoRu38776224','HaRu19601224','SoRu38869224''AmRu14089224')
These are the sources' ids where the queue average time is more than 8 hours aka 500 minutes.
Thus we need to figure out what are types of these water sources. */

SELECT source_id, type_of_water_source
FROM md_water_services.water_source
WHERE source_id IN ('SoRu35083224','SoKo33124224','KiRu26095224','SoRu38776224','HaRu19601224','SoRu38869224''AmRu14089224');


-- Fourthly we assess the water quality of the water sources that were visited by our agents.
SELECT TOP 20
   *
FROM md_water_services.water_quality
   INNER JOIN md_water_services.visits
   ON md_water_services.water_quality.record_id = md_water_services.visits.record_id;

/* Now we start to look for errors in the data.
Our agents supposedly did not visit any sources more than once except for shared taps sources.
Consequently, we look into the tap_in_home sources that were visited more than once and are scored 10
to see if there are errors in the records. 
The ideal result should be zero rows are found achieving these conditions.*/
SELECT
   visits.record_id,
   visits.source_id,
   visits.visit_count,
   visits.time_in_queue,
   water_quality.subjective_quality_score,
   water_source.type_of_water_source
FROM
   visits
   INNER JOIN
   water_quality ON visits.record_id = water_quality.record_id
   INNER JOIN
   water_source ON visits.source_id = water_source.source_id
WHERE 
    water_quality.subjective_quality_score = 10
   AND visits.visit_count > 1
   AND water_source.type_of_water_source = "tap_in_home";
-- 216 rows are found which means there are errors in the records.

-- Now we start cleaning the data
-- We first look into the well pollution table to see if there are any issues.
SELECT *
FROM well_pollution;

/*We see if there is a correlation between the results of the wells being Clean and the Discription having the word Clean
to check if there are any errors as there is Clean Bacteria in the describtion so things could be mixed up. */
SELECT *
FROM well_pollution
WHERE well_pollution.description LIKE '%Clean_%';
-- There are 200 rows found

-- To avoid any mistakes in the future we update the Clean Bacteria descriptions to Bacteria
UPDATE md_water_services.well_pollution
SET well_pollution.description = 'Bacteria: Giardia Lamblia'
WHERE well_pollution.description = 'Clean Bacteria: Giardia Lamblia';

UPDATE md_water_services.well_pollution
SET well_pollution.description = 'Bacteria: E. coli'
WHERE well_pollution.description = 'Clean Bacteria: E. coli';

/*We also update the results of the wells that have biological levels higher than 0.01 and their results were clean 
to Contaminated: Biological as they are polluted. */
UPDATE md_water_services.well_pollution
SET results = 'Contaminated: Biological'
WHERE biological > 0.01
   AND results = 'Clean';

-- We check if the updates were successful
SELECT *
FROM well_pollution
WHERE biological>0.01
   AND description = 'Clean';
-- 0 rows are found which means the updates were successful.

-- Now, we focus on the employee table.

-- We need to update the employee table to have the correct email addresses since the email column was empty.

-- We first check the employee table to see if there are any issues.
SELECT
   employee_name,
   CONCAT(REPLACE(LOWER(employee_name),' ','.'),"@ndogowater.gov") AS employee_email
FROM employee;

-- Now, we update the email column with the correct email addresses since there was no issues.
UPDATE employee
SET email = CONCAT(REPLACE(LOWER(employee_name),' ','.'),"@ndogowater.gov");

SELECT email
FROM employee;
-- Check if the email column is updated correctly.

-- Clean the phone number column in the employee table.

-- We first check the phone number column to see if there are any issues.
SELECT phone_number
FROM employee;

-- We check the length of the phone numbers to see if there are any issues.
SELECT LENGTH(phone_number)
FROM employee;
-- some phone numbers have more than 12 characters which is incorrect.

-- We trim the phone numbers to remove any extra spaces.
SELECT phone_number,
   TRIM(phone_number) AS trimmed
FROM employee;

-- We update the phone numbers to have the correct format.
UPDATE employee
SET phone_number = TRIM(phone_number);

-- We check if the updates were successful.
SELECT phone_number
FROM employee
WHERE LENGTH(phone_number) <> 12;
-- 0 rows are found which means the updates were successful.


-- Now, we count the employees living in each town.
SELECT town_name,
   COUNT(employee_name) AS number_of_employees_living_there
FROM employee
GROUP BY (town_name);


-- We check the employees with the most visits
SELECT assigned_employee_id,
   COUNT(visit_count) AS total_visits
FROM visits
GROUP BY assigned_employee_id
ORDER BY total_visits DESC;

-- The top 3 employees are the ones whose ids are 1,30 and 34. We select these employees to see their details.
SELECT assigned_employee_id, employee_name, phone_number, email
FROM employee
WHERE assigned_employee_id IN (1,30,34);


-- RECORDS PER TOWN
SELECT town_name,
   COUNT(record_id) AS records_per_town
FROM location, visits
WHERE location.location_id = visits.location_id
GROUP BY town_name;

-- LOCATION PER TOWN
SELECT town_name,
   COUNT(location_id) AS locations_per_town
FROM location
GROUP BY (town_name);

-- LOCATION PER PROVINCE
SELECT province_name,
   COUNT(location_id) AS locations_per_province
FROM location
GROUP BY (province_name);

-- RECORDS PER PROVINCE AND TOWN
SELECT province_name, town_name,
   COUNT(location_id) AS records_per_town
FROM location
GROUP BY province_name, town_name
ORDER BY province_name,town_name desc;

-- RECORDS PER LOCATION TYPE
SELECT location_type,
   COUNT(location_id) AS records
FROM location
GROUP BY location_type;

-- No we start answering questiosn about the water sources and the visits.
-- 1. How many people did we survey in total?
SELECT
   SUM(number_of_people_served)
FROM water_source;

-- 2. How many wells, taps and rivers are there?
SELECT type_of_water_source,
   COUNT(type_of_water_source) AS counts
FROM water_source
GROUP BY type_of_water_source;

SELECT
   COUNT(type_of_water_source) AS numbers_of_taps
FROM water_source
WHERE type_of_water_source LIKE '%tap%';

-- 3. How many people share particular types of water sources on average?
SELECT type_of_water_source,
   ROUND(AVG(number_of_people_served)) AS average_of_people
FROM water_source
GROUP BY type_of_water_source;

-- 4. How many people are getting water from each type of source?
SELECT type_of_water_source,
   SUM(number_of_people_served) AS average_of_people
FROM water_source
GROUP BY type_of_water_source;


-- USING PERCENTAGES
SELECT
   SUM(number_of_people_served)
FROM water_source;

SELECT type_of_water_source,
   ROUND(SUM(number_of_people_served) *100 / 27628140, 2) AS average_of_people
FROM water_source
GROUP BY type_of_water_source;

-- RANKING THE TYPES OF SOURCES BASED ON THE USAGE
SELECT type_of_water_source,
   SUM(number_of_people_served) AS number_of_people,
   RANK() OVER(ORDER BY SUM(number_of_people_served) DESC) AS RANK_OF_TYPES
FROM water_source
GROUP BY type_of_water_source;

SELECT source_id,
   type_of_water_source,
   number_of_people_served,
   ROW_NUMBER() OVER(PARTITION BY type_of_water_source
ORDER BY number_of_people_served DESC) AS piriority_rank
FROM water_source
WHERE type_of_water_source IN ('shared_tap', 'well', 'river');

-- 1. How long did the survey take?
SELECT DATEDIFF(MAX(CAST(time_of_record AS DATE)), MIN(CAST(time_of_record AS DATE))) AS period_in_days
FROM visits;

-- 2. What is the average total queue time for water?
SELECT
   AVG(NULLIF(time_in_queue,0)) AS average_total_queue_time
FROM visits;

-- 3. What is the average queue time on different days?
SELECT DAYNAME(time_of_record) AS NAME_OF_DAY,
   ROUND(AVG(NULLIF(time_in_queue,0))) AS AVG_QUEUE_TIME
FROM visits
GROUP BY NAME_OF_DAY;

-- 4. How can we communicate this information efficiently?
SELECT TIME_FORMAT(TIME(time_of_record), '%H:00') AS hour_of_day,
   ROUND(AVG(NULLIF(time_in_queue,0))) AS AVG_QUEUE_TIME
FROM visits
GROUP BY hour_of_day
ORDER BY hour_of_day;

SELECT
   TIME_FORMAT(TIME(time_of_record), '%H:00') AS hour_of_day,
   -- Sunday
   ROUND(AVG(
   CASE
      WHEN DAYNAME(time_of_record) = 'Sunday' THEN time_in_queue
      ELSE NULL
   END
   ),0) AS Sunday,
   -- Monday
   ROUND(AVG(
   CASE
      WHEN DAYNAME(time_of_record) = 'Monday' THEN time_in_queue
      ELSE NULL
   END
   ),0) AS Monday,
   -- Tuesday
   ROUND(AVG(
   CASE
      WHEN DAYNAME(time_of_record) = 'Tuesday' THEN time_in_queue
      ELSE NULL
   END
   ),0) AS Tuesday,
   -- Wednesday
   ROUND(AVG(
   CASE
      WHEN DAYNAME(time_of_record) = 'Wednesday' THEN time_in_queue
      ELSE NULL
   END
   ),0) AS Wednesday,
   -- thursday
   ROUND(AVG(
   CASE
      WHEN DAYNAME(time_of_record) = 'Thursday' THEN time_in_queue
      ELSE NULL
   END
   ),0) AS Thursday,
   -- friday
   ROUND(AVG(
   CASE
      WHEN DAYNAME(time_of_record) = 'Friday' THEN time_in_queue
      ELSE NULL
   END
   ),0) AS Friday,
   -- Saturday
   ROUND(AVG(
   CASE
      WHEN DAYNAME(time_of_record) = 'Saturday' THEN time_in_queue
      ELSE NULL
   END
   ),0) AS Saturday
FROM
   visits
WHERE
time_in_queue != 0
-- this excludes other sources with 0 queue times
GROUP BY hour_of_day
ORDER BY hour_of_day;


-- Now we add the table with the auditor report to the database
DROP TABLE IF EXISTS [auditor_report];
CREATE TABLE [auditor_report] (
[location_id] VARCHAR(32),
[type_of_water_source] VARCHAR(64),
[true_water_source_score] int DEFAULT NULL,
[statements] VARCHAR(255)
);





-- Common Table Expression (CTE) to calculate the difference in scores betwwen the auditor's report and the employees' scores.
WITH Comparison_Report AS (
    SELECT 
        auditor_report.true_water_source_score AS auditor_score,            
        water_quality.subjective_quality_score AS survyor_score,           
        auditor_report.location_id AS Location_id,                          
        (auditor_report.true_water_source_score - water_quality.subjective_quality_score) AS DIFFERENCE, -- Difference in scores
        water_quality.record_id AS record_id,                               
        employee.employee_name AS employee_name                             
    FROM 
        auditor_report
    INNER JOIN 
        visits ON auditor_report.location_id = visits.location_id           
    INNER JOIN 
        water_quality ON visits.record_id = water_quality.record_id         
    INNER JOIN 
        employee ON visits.assigned_employee_id = employee.assigned_employee_id 
    WHERE 
        visits.visit_count = 1 -- Filter for the first visit
        AND (auditor_report.true_water_source_score - water_quality.subjective_quality_score) <> 0 -- Only include rows where scores differ
),

-- CTE to count errors made by each employee
error_count AS (
    SELECT 
        employee_name,                                                      
        COUNT(employee_name) AS number_of_mistakes                       
    FROM 
        Comparison_Report
    GROUP BY 
        employee_name                                                     
)

-- Final query to select employees with more than 6 mistakes as this probably indicates a problem or corruption.
SELECT 
    employee_name,                                                         
    number_of_mistakes                                                     
FROM 
    error_count
WHERE 
    number_of_mistakes > 6;                                                



-- Now we create a view to store the incorrect records
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

-- 'Bello Azibo' , 'Lalitha Kaburi' , 'Malachi Mavuso' , 'Bello Azibo' these employees have fishy behavior.



CREATE VIEW combined_analysis_table AS
-- This view assembles data from different tables into one to simplify analysis
SELECT
water_source.type_of_water_source AS source_type,
location.town_name, location.province_name, location.location_type,
water_source.number_of_people_served AS people_served, visits.time_in_queue,
well_pollution.results
FROM visits
LEFT JOIN well_pollution
ON well_pollution.source_id = visits.source_id
INNER JOIN location
ON location.location_id = visits.location_id
INNER JOIN water_source
ON water_source.source_id = visits.source_id
WHERE visits.visit_count = 1;


WITH province_totals AS (-- This CTE calculates the population of each province
SELECT province_name,
SUM(people_served) AS total_people_served
FROM
combined_analysis_table
GROUP BY
province_name
)
SELECT
ct.province_name,
-- These case statements create columns for each type of source.
-- The results are aggregated and percentages are calculated
ROUND((SUM(CASE WHEN source_type = 'river'
THEN people_served ELSE 0 END) * 100.0 / pt.total_people_served), 0) AS river,
ROUND((SUM(CASE WHEN source_type = 'shared_tap'
THEN people_served ELSE 0 END) * 100.0 / pt.total_people_served), 0) AS shared_tap,
ROUND((SUM(CASE WHEN source_type = 'tap_in_home'
THEN people_served ELSE 0 END) * 100.0 / pt.total_people_served), 0) AS tap_in_home,
ROUND((SUM(CASE WHEN source_type = 'tap_in_home_broken'
THEN people_served ELSE 0 END) * 100.0 / pt.total_people_served), 0) AS tap_in_home_broken,
ROUND((SUM(CASE WHEN source_type = 'well'
THEN people_served ELSE 0 END) * 100.0 / pt.total_people_served), 0) AS well
FROM
combined_analysis_table AS ct
JOIN
province_totals AS pt ON ct.province_name = pt.province_name
GROUP BY
ct.province_name
ORDER BY
ct.province_name;

SELECT *
FROM province_totals;

-- Now we create a temporary table to store the aggregated data for each town
CREATE TEMPORARY TABLE town_aggregated_water_access
WITH town_totals AS (-- This CTE calculates the population of each town
-- Since there are two Harare towns, we have to group by province_name and town_name
SELECT province_name, town_name, SUM(people_served) AS total_ppl_serv
FROM combined_analysis_table
GROUP BY province_name,town_name
)
SELECT
ct.province_name,
ct.town_name,
ROUND((SUM(CASE WHEN source_type = 'river'
THEN people_served ELSE 0 END) * 100.0 / tt.total_ppl_serv), 0) AS river,
ROUND((SUM(CASE WHEN source_type = 'shared_tap'
THEN people_served ELSE 0 END) * 100.0 / tt.total_ppl_serv), 0) AS shared_tap,
ROUND((SUM(CASE WHEN source_type = 'tap_in_home'
THEN people_served ELSE 0 END) * 100.0 / tt.total_ppl_serv), 0) AS tap_in_home,
ROUND((SUM(CASE WHEN source_type = 'tap_in_home_broken'
THEN people_served ELSE 0 END) * 100.0 / tt.total_ppl_serv), 0) AS tap_in_home_broken,
ROUND((SUM(CASE WHEN source_type = 'well'
THEN people_served ELSE 0 END) * 100.0 / tt.total_ppl_serv), 0) AS well
FROM
combined_analysis_table ct
JOIN -- Since the town names are not unique, we have to join on a composite key
town_totals tt ON ct.province_name = tt.province_name AND ct.town_name = tt.town_name
GROUP BY -- We group by province first, then by town.
ct.province_name,
ct.town_name
ORDER BY
ct.town_name;



SELECT * FROM town_aggregated_water_access
ORDER BY province_name, town_name;

SELECT province_name, town_name,
ROUND(tap_in_home_broken / (tap_in_home_broken + tap_in_home) *100,0) AS Pct_broken_taps
FROM town_aggregated_water_access;




CREATE TABLE Project_progress (
Project_id SERIAL PRIMARY KEY, /* Project_id -- Unique key for sources in case we visit the same
source more than once in the future.*/
source_id VARCHAR(20) NOT NULL REFERENCES water_source(source_id) ON DELETE CASCADE ON UPDATE CASCADE,
/* source_id -- Each of the sources we want to improve should exist,
and should refer to the source table. This ensures data integrity.*/
Address VARCHAR(50), -- Street address
Town VARCHAR(30),
Province VARCHAR(30),
Source_type VARCHAR(50),
Improvement VARCHAR(50), -- What the engineers should do at that place
Source_status VARCHAR(50) DEFAULT 'Backlog' CHECK (Source_status IN ('Backlog', 'In progress', 'Complete')),
/* Source_status -- We want to limit the type of information engineers can give us, so we limit Source_status.
− By DEFAULT all projects are in the "Backlog" which is like a TODO list.
− CHECK() ensures only those three options will be accepted. This helps to maintain clean data.*/
Date_of_completion DATE, -- Engineers will add this the day the source has been upgraded.
Comments TEXT -- Engineers can leave comments. We use a TEXT type that has no limit on char length
);

truncate project_progress;

-- Project_progress_query
INSERT INTO project_progress (Address, Town, Province, source_id, Source_type, Improvement)
SELECT location.address, location.town_name, location.province_name,
water_source.source_id, water_source.type_of_water_source,
CASE
WHEN water_source.type_of_water_source = 'shared_tap' AND visits.time_in_queue >=30
THEN CONCAT("Install ", FLOOR(visits.time_in_queue/30), " taps nearby")
WHEN water_source.type_of_water_source = 'river'
THEN 'Add Drill well'
WHEN well_pollution.results = 'Contaminated: Chemical'
THEN 'Install RO filter'
WHEN well_pollution.results = 'Contaminated: Biological'
THEN 'Install UV and RO filter'
WHEN water_source.type_of_water_source = 'tap_in_home_broken'
THEN 'Diagnose local infrastructure.'
ELSE NULL
END AS Improvments
FROM water_source
LEFT JOIN well_pollution
ON water_source.source_id = well_pollution.source_id
INNER JOIN visits
ON water_source.source_id = visits.source_id
INNER JOIN location 
ON location.location_id = visits.location_id
WHERE visits.visit_count = 1
AND (
well_pollution.results != 'Clean'
OR water_source.type_of_water_source IN ('tap_in_home_broken', 'river')
OR (water_source.type_of_water_source = 'shared_tap' AND visits.time_in_queue>= 30)
);


SELECT * FROM project_progress;
























