-- We start by looking for the employee who is a Micro Biologist
SELECT employee.employee_name,employee.phone_number
FROM employee
WHERE employee.position = 'Micro Biologist';


SELECT DISTINCT *
FROM employee;

SELECT *
FROM water_source;

SELECT number_of_people_served,source_id
FROM water_source
WHERE source_id IN ('AkRu04862224','AkRu05603224','AmAs10911224','AkHa00036224');

SELECT pop_n
FROM global_water_access
WHERE name= 'Maji Ndogo';

SELECT *
FROM employee
WHERE position = 'Civil Engineer' AND (province_name = 'Dahabu' OR address LIKE '%Avenue%');

SELECT *
FROM employee
WHERE phone_number LIKE '%11%';

-- # assigned_employee_id, employee_name, phone_number, email, address, province_name, town_name, position
-- '1', 'Bello Azibo', '+99643864786 ', NULL, '129 Ziwa La Kioo Road', 'Kilimani', 'Rural', 'Field Surveyor'
-- '5', 'Zuriel Matembo', '+99034075111 ', NULL, '26 Bahari Ya Faraja Road', 'Kilimani', 'Rural', 'Field Surveyor'

SELECT *
FROM well_pollution
WHERE description LIKE 'Clean_%' OR results = 'Clean' AND biological < 0.01;


UPDATE employee
SET phone_number = '+99643864786'
WHERE employee_name = 'Bello Azibo';

SELECT COUNT(*) 
FROM well_pollution
WHERE description
IN ('Parasite: Cryptosporidium', 'biologically contaminated')
OR (results = 'Clean' AND biological > 0.01);

