# Retail Sales and Customer Demographics Dataset Analysis

## Project Overview
This project involves an exploratory data analysis (EDA) of a synthetic retail sales and customer demographics dataset. The goal is to derive actionable insights about customer behavior and sales trends to help improve business strategies.

---

## Dataset Overview
- **Attributes**:
  - Transaction ID
  - Date
  - Customer ID
  - Gender
  - Age
  - Product Category
  - Quantity
  - Price per Unit
  - Total Amount
- **Rows**: 998 unique transactions
- **License**: CC0: Public Domain
- **Update Frequency**: Never
- **Original Dataset**: [https://www.kaggle.com/datasets/mohammadtalib786/retail-sales-dataset?resource=download]

---

## Data Preparation
### Steps Performed:
1. **Added Month and Day Columns**:
   - Extracted month and day from the transaction dates to analyze time-based patterns.

2. **Created Age Groups**:
   - Divided customer ages into the following groups to identify trends across demographics:
     - 18-22: Likely students or part-time workers.
     - 23-26: Full-time workers without family obligations.
     - 27-30: Early-stage family obligations.
     - 31-40, 41-50, 50-64: Progressive increase in family and financial responsibilities.

3. **Removed Outliers**:
   - Deleted two entries from 2024 since the focus was solely on 2023 data.

4. **Cleaned the Dataset**:
   - Ensured the data was free of duplicates, inconsistencies, and missing values.

---

## Analysis and Insights
### Key Metrics:
- **Revenue**: $454K
- **Total Quantity Sold**: 2,510
- **Unique Customers**: 998
- **Average Transaction Value (ATV)**: $455.38
- **Average Price per Unit**: $179.72

### Gender-Based Insights:
1. Male customers represent 48.9%, while female customers account for 51.1%.
2. Male customers spend more on average per transaction despite being slightly fewer in number.

### Age Group Insights:
1. **50-64 Age Group**:
   - Contributes the highest revenue and quantity sold.
   - Females in this group purchase clothing predominantly in May, August, October, and September, while electronics peak in August.

2. **18-22 Age Group**:
   - Spends significantly in February and November.
   - Male customers focus on electronics in May and June, while females prioritize beauty products in February.

3. **27-30 Age Group**:
   - Lowest purchasing age group among males.

4. **31-40 Age Group**:
   - Females tend to purchase electronics in the last quarter of the year and make purchases mostly on Thursdays.

### Product Category Insights:
1. **Top Categories by Revenue**:
   - Electronics and Clothing (34.2% and 34.3% respectively).
2. **Beauty Products**:
   - Popular among younger demographics (18-30), especially females.

### Temporal Insights:
1. **Monthly Trends**:
   - Highest sales in May, followed by October.
   - Significant drop in sales during September and March.

2. **Weekly Trends**:
   - Most purchases occur on Sundays, Mondays, and Tuesdays.

### Customer Retention Insight:
- Each transaction is associated with a unique customer, suggesting no repeat purchases. 
  **Recommendation**: Implement customer follow-up and loyalty programs to improve retention.

---

## Recommendations
1. **Improve Customer Retention**:
   - Introduce loyalty programs and personalized offers to encourage repeat purchases.
   - Conduct post-purchase surveys to address customer complaints and preferences.

2. **Seasonal Promotions**:
   - Focus marketing efforts on May and October to capitalize on peak sales.
   - Develop strategies to boost sales during September and March.

3. **Product-Specific Strategies**:
   - Expand inventory for Electronics and Clothing categories.
   - Target Beauty category promotions towards the 18-30 age group, especially females.

4. **Day-Based Campaigns**:
   - Schedule promotional offers on Sundays, Mondays, and Tuesdays to align with peak purchasing days.

5. **Demographic-Focused Marketing**:
   - Design campaigns tailored to the preferences of different age groups:
     - 50-64: Electronics in August and Clothing in Q2/Q3.
     - 18-22: Beauty in February and November.
     - 31-40: Electronics in Q4.

---

## Interactive Dashboard
You can explore the interactive dashboard for this analysis here: (Interactive Dashboard Link)[(https://app.powerbi.com/links/r-mISatAeI?ctid=f349c2fd-fc94-4893-abe4-cfbe7ed52842&pbi_source=linkShare)](#)

---

### Dashboard Previews:
#### Sales & Customers:
![Dashboard: Sales](![Sales](https://github.com/user-attachments/assets/031978d4-28ca-4ddd-8577-d2d479fcd685)
) 

#### Sales Trends:
![Dashboard: Trends](![Trends](https://github.com/user-attachments/assets/f591f6e6-b942-49ab-9b22-2bb91cda6ed8)
)

---

## Tools Used
- **Data Cleaning**: Excel
- **Visualization**: Power BI

---


## Conclusion
This analysis highlights significant trends and actionable insights that can drive better decision-making in retail strategies. By implementing the outlined recommendations, businesses can enhance customer retention, optimize inventory management, and maximize revenue potential.

---

