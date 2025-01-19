# Layoffs Data Analysis Project

## Overview
This project involves analyzing a dataset containing information about layoffs across various companies and industries from 2020 to 2023. The goal of this project was to clean the data, ensure its consistency, and perform exploratory data analysis to derive insights.

## Tools Used
- **Database**: MySQL
- **Language**: SQL
- **Dataset Format**: CSV

---

## Data Cleaning Steps
1. **Database Creation**:
   - Created a database named `layoffs` and imported the raw CSV dataset into a table.
   
2. **Staging Table**:
   - Created a staging table to store the raw dataset as a backup for recovery in case of errors.

3. **Duplicate Removal**:
   - Identified duplicates using a window function (`ROW_NUMBER`) partitioned by all columns.
   - Created a new table containing the raw dataset with a `row_num` column to delete duplicate entries.
   - Dropped the `row_num` column after removing duplicates.

4. **Data Standardization**:
   - Trimmed spaces from the `company` column.
   - Standardized entries in the `industry` column (e.g., merged "Crypto", "Crypto Currency", and "CryptoCurrency" into "Crypto").
   - Converted location names like `'DÃ¼sseldorf'`, `'FlorianÃ³polis'`, and `'MalmÃ¶'` to Latin script.
   - Removed full stops from country names (e.g., `'United States.'` -> `'United States'`).
   - Changed the `date` column format from `MM/DD/YYYY` (text) to the standard SQL `DATE` format.

5. **Handling Null Values**:
   - Updated missing `industry` values based on other entries with the same company name using self-joins.
   - Deleted companies with no additional entries and missing critical information (e.g., `'Bally's Interactive'`).
   - Removed entries lacking information about layoffs.

---

## Data Exploratory Analysis (EDA)
1. **Maximum Layoffs**:
   - **Total layoffs**: 12,000 (largest by a single company).
   - **Percentage layoffs**: 100% (some companies laid off all employees).

2. **Companies with 100% Layoffs**:
   - Total: 116 companies.
   - Largest layoffs: `'Katerra'` laid off 2,434 employees.

3. **Funding Analysis**:
   - `'Britishvolt'` had the highest funding among companies with 100% layoffs, totaling $2.6 billion USD.

4. **Top Companies by Layoffs**:
   - Amazon: 18,150 layoffs.
   - Google: 12,000 layoffs.
   - Meta: 11,000 layoffs.

5. **Date Analysis**:
   - **Oldest date**: `'2020-03-11'`.
   - **Most recent date**: `'2023-03-06'`.
   - The dataset covers layoffs over three years, beginning from the COVID-19 pandemic.

6. **Industry Analysis**:
   - Top industries by layoffs:
     - Consumer: 45,452 layoffs.
     - Retail: 43,444 layoffs.
     - Transportation: 36,224 layoffs.
   - Lowest industries by layoffs:
     - Manufacturing: 20 layoffs.
     - Fin-Tech: 325 layoffs.
     - Aerospace: 661 layoffs.

7. **Country Analysis**:
   - Top countries by layoffs:
     - United States: 256,559 layoffs.
     - India: 35,993 layoffs.
     - Netherlands: 17,220 layoffs.
   - **Observation**: The U.S. dominates the dataset with 1,293 companies, followed by India with 140 companies. The Netherlands had only 12 companies but significant layoffs.

8. **Yearly Layoffs**:
   - Layoffs by year:
     - 2022: 160,661 layoffs.
     - 2023: 125,677 layoffs (data includes only the first 3 months).
     - 2020: 80,998 layoffs.
     - 2021: 15,823 layoffs.

9. **Layoffs by Stage**:
   - Post-IPO: 204,132 layoffs (largest stage).
   - Acquired: 27,576 layoffs.
   - Series C: 20,017 layoffs.

10. **Monthly Layoffs**:
    - January had the highest layoffs (92,037), followed by November (55,758) and February (41,046).

11. **Layoffs by Month-Year**:
    - Largest layoffs:
      - January 2023: 84,714 layoffs.
      - November 2022: 53,451 layoffs.
      - February 2023: 36,493 layoffs.

12. **Cumulative Layoffs**:
    - Analyzed using window functions and Common Table Expressions (CTEs).
    - Layoffs showed a significant increase from 2022 to 2023.

13. **Company-Year Analysis**:
    - Google had 12,000 layoffs in early 2023.
    - Meta had 11,000 layoffs in 2022.
    - Amazon had 10,150 layoffs in 2022.
    - Microsoft had 10,000 layoffs in early 2023.

14. **Top Companies by Year**:
    - 2020: Uber (7,525 layoffs).
    - 2021: Bytedance (3,600 layoffs).
    - 2022: Meta (11,000 layoffs).
    - 2023: Google (12,000 layoffs).

---

## Key Insights
- Layoffs peaked in 2022, with significant numbers continuing into early 2023.
- The consumer, retail, and transportation industries were hit the hardest.
- The U.S. experienced the largest layoffs due to the predominance of American companies in the dataset.
- January consistently showed high layoffs, likely due to fiscal year-end reviews and restructuring.

---

## Project Highlights
- Demonstrated expertise in SQL data cleaning and MySQL-specific constraints.
- Used advanced SQL techniques, including window functions and CTEs, to derive insights.
- Identified critical business and industry trends over three years of layoff data.

---

## Future Work
- Include visualization tools like Tableau or PowerBI to better represent trends.
- Analyze correlations between funding, industry stage, and layoff percentages.
- Expand the dataset to include more countries for a global perspective.

---

## Author
**Mariam Khaled**  
Bachelor in Computer & Systems Engineering  
Graduation Year: 2024  
GitHub: [Your GitHub Link]  
LinkedIn: [Your LinkedIn Link]  
