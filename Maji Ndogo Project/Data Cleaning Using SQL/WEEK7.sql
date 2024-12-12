USE md_water_services;

-- #1 CLEAN THE DATA

-- UPDATE THE EMPLOYEES EMAILS
SELECT 
employee_name,
CONCAT(REPLACE(LOWER(employee_name),' ','.'),"@ndogowater.gov") AS employee_email
FROM employee;

UPDATE employee
SET email = CONCAT(REPLACE(LOWER(employee_name),' ','.'),"@ndogowater.gov");

SELECT email FROM employee;

-- CLEAN PHONE NUMBER
SELECT phone_number FROM employee;

SELECT LENGTH(phone_number) FROM employee;

SELECT phone_number,
TRIM(phone_number) AS trimmed
FROM employee;

UPDATE employee
SET phone_number = TRIM(phone_number);

SELECT phone_number
FROM employee
WHERE LENGTH(phone_number) <> 12;

-- COUNT OF EMPLOYEES IN EACH TOWN
SELECT town_name,
COUNT(employee_name) AS number_of_employees_living_there
FROM employee
GROUP BY (town_name);

-- Employees with the most visits
SELECT assigned_employee_id,
COUNT(visit_count) AS total_visits
FROM visits
GROUP BY assigned_employee_id
ORDER BY total_visits DESC;

-- THE TOP 3 EMPLOYEES ARE 1,30,34
SELECT assigned_employee_id, employee_name,phone_number,email
FROM employee
WHERE assigned_employee_id IN (1,30,34);


-- RECORDS PER TOWN
SELECT town_name,
COUNT(record_id) AS records_per_town
FROM location,visits
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
SELECT province_name,town_name,
COUNT(location_id) AS records_per_town
FROM location
GROUP BY province_name, town_name
ORDER BY province_name,town_name desc;

-- RECORDS PER LOCATION TYPE
SELECT location_type,
COUNT(location_id) AS records
FROM location
GROUP BY location_type;

-- 1. How many people did we survey in total?
SELECT
	SUM(number_of_people_served)
FROM water_source;

-- 2. How many wells, taps and rivers are there?
SELECT DISTINCT type_of_water_source
FROM water_source;

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
ORDER BY hour_of_day
LIMIT 24;

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
time_in_queue != 0 -- this excludes other sources with 0 queue times
GROUP BY
hour_of_day
ORDER BY
hour_of_day;














