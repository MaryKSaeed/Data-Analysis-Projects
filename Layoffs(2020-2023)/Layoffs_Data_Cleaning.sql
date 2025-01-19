-- Database Creation
CREATE DATABASE layoffs;

-- Database Activation
USE layoffs;

-- View how the data looks like
SELECT *
FROM layoffs.layoffs;

-- Create a staging table to keep raw dataset safe
CREATE TABLE layoffs_staging
LIKE layoffs.layoffs;

-- Fill the staging table with the raw data
INSERT INTO layoffs_staging
SELECT *
FROM layoffs.layoffs;

-- View staging table to make sure everything is right
SELECT *
FROM layoffs_staging;

-- Begining of Data Cleaning
-- 1- Remove Duplicates

-- Check the duplicate rows, if the row_num > 1 then there is a high chance the row is a duplicate
WITH duplication_check AS(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions
) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplication_check 
WHERE row_num > 1;

-- Check if these are actually the duplicates
SELECT *
FROM layoffs_staging
WHERE company IN ('Casper','Cazoo','Hibob', 'Yahoo','Wildlife Studios')
ORDER BY company;

/* Create another staging table that includes the row_num table to remove duplicates from the dataset
as it is not possible to delete rows from CTEs in MySQL */
CREATE TABLE `layoffs_duplicates` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Fill the new table with data
INSERT INTO layoffs_duplicates
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions
) AS row_num
FROM layoffs_staging;

-- Delete the duplicates
DELETE
FROM layoffs_duplicates
WHERE row_num > 1;

-- Check if everything is fine if the resulting set is empty then it is fine.
SELECT *
FROM layoffs_duplicates
WHERE row_num > 1;

-- Drop the row_num column as we do not need it anymore
ALTER TABLE layoffs_duplicates
DROP COLUMN row_num;

-- Check the table
SELECT *
FROM layoffs_duplicates;

-- 2- Standardaizing the data
-- Check the spaces in column company
SELECT company, TRIM(company) AS company_trimed
FROM layoffs_duplicates;

-- Update the company column to be trimmed
UPDATE layoffs_duplicates
SET company = TRIM(company);

-- Check the column industry
SELECT DISTINCT industry 
FROM layoffs_duplicates
ORDER BY 1;

-- There are these records (Crypto, Crypto Currency, CryptoCurrency) which are the same industry so it should be fixed
UPDATE layoffs_duplicates
SET industry = 'Crypto'
WHERE industry IN ('Crypto Currency', 'CryptoCurrency');

-- Check the location column
SELECT DISTINCT location
FROM layoffs_duplicates
ORDER BY 1; -- 'DÃ¼sseldorf' , 'FlorianÃ³polis' , 'MalmÃ¶', 'Non-U.S.'

-- Check the locations I found weird
SELECT *
FROM layoffs_duplicates
WHERE location IN ('DÃ¼sseldorf' , 'FlorianÃ³polis' , 'MalmÃ¶', 'Non-U.S.')
ORDER BY location;

-- Update the locations
UPDATE layoffs_duplicates
SET location = 'Düsseldorf'
WHERE location = 'DÃ¼sseldorf';

UPDATE layoffs_duplicates
SET location = 'Florianópolis'
WHERE location = 'FlorianÃ³polis';

UPDATE layoffs_duplicates
SET location = 'Malmö'
WHERE location = 'MalmÃ¶';

-- Check the country column
SELECT DISTINCT country
FROM layoffs_duplicates
ORDER BY 1;

-- Update the country column
UPDATE layoffs_duplicates
SET country = 'United States'
WHERE country = 'United States.';

-- Format the date column As DATE type instead of Text, the format of date text was mm/dd/yyyy so we will change it to standard date format
SELECT date,
STR_TO_DATE(date, '%m/%d/%Y') AS formatted_date
FROM layoffs_duplicates;

UPDATE layoffs_duplicates
SET date = STR_TO_DATE(date, '%m/%d/%Y');

-- change the datatype of the column from text to date
ALTER TABLE layoffs_duplicates
MODIFY COLUMN date DATE;

SELECT *
FROM layoffs_duplicates;

-- Check the stage column
SELECT DISTINCT stage
FROM layoffs_duplicates; -- looks like everything is alright. 


-- 3- Null values & blank values
-- We look at the nulls in column industry
SELECT *
FROM layoffs_duplicates
WHERE industry IS NULL
OR industry = '';

-- We check if the companies that have null industries have other entries to get the industry from the other entries
SELECT *
FROM layoffs_duplicates AS t1
JOIN layoffs_duplicates AS t2
ON t1.company = t2.company
AND t1.location = t2.location
WHERE t1.industry IS NOT NULL
AND (t2.industry IS NULL OR t2.industry = '');

-- Updating the industries in those companies
UPDATE layoffs_duplicates AS t1
JOIN layoffs_duplicates AS t2
ON t1.company = t2.company
AND t1.location = t2.location
SET t1.industry = t2.industry
WHERE t1.industry = ''
AND t2.industry IS NOT NULL
AND t2.industry <> '';

-- Delete the entry where company = Bally's Interactive
SELECT *
FROM layoffs_duplicates
WHERE company LIKE 'Bal%';

DELETE
FROM layoffs_duplicates
WHERE company = "Bally's Interactive";

-- We look at the NULL values in the laid off columns
SELECT *
FROM layoffs_duplicates
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- I will delete all the entries that do not have any information about the layoffs as they hold no importance or effect on my analysis
DELETE
FROM layoffs_duplicates
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;


