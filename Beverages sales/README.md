# **Soft Drinks Sales Dashboard**

## **Objective**
The goal of this project was to create an interactive dashboard that provides detailed insights into the sales and gross profit trends of soft drinks across various product sizes, client types, and brands. The dashboard empowers stakeholders to analyze and explore sales data effectively through dynamic filtering and intuitive visualizations.

---

## **Project Overview**

### **1. Data Preparation**
To ensure the data was accurate, consistent, and ready for visualization, the following steps were carried out:

- **Cleaning and Transformation**:  
  Raw sales data was cleaned and transformed using Excel functions and PivotTables to eliminate inconsistencies and align it with the dashboard's requirements.

- **Reference Sheet**:  
  A reference sheet was created to:
  - Map the months and years mentioned in the dataset for precise filtering.  
  - Provide a reference cell for radio button functionality, enabling dynamic filtering options.

- **Structured Tables**:  
  Key tables were built, including:
  - A **Date Table** to enable time-based filtering, such as "Last Twelve Months" (LTM) or "Year to Date" (YTD).
  - Net Sales and GP Development, Volume by Size, and Volume by Client Type tables to compute aggregated metrics dynamically using 'Pivot Tables' and functions like `IFERROR`, `VLOOKUP`, and `SUM`.

- **Dynamic Slicers**:  
  Slicers were added for filtering based on brand, making the dashboard more interactive and user-friendly.

---

### **2. Dashboard Design**
Both Excel and Tableau were used to create interactive dashboards, focusing on usability and impactful visualizations. Key design elements include:

- **Dynamic Metrics**:  
  The dashboard provides insights into:
  - **Net Sales** and **Gross Profit (%)** development over time.  
  - **Volume Distribution** by product size and client type.

- **Filters and Interactivity**:  
  - Dropdown menus and radio buttons allow filtering by specific time periods such as LTM or YTD.  
  - Brand-level filtering enables stakeholders to focus on particular products.

- **Visualization Features**:  
  - Clean, professional layouts for easy interpretation of metrics.
  - Interactive charts for exploring trends in sales and gross profit percentages.

---

## **Key Features**
- Dynamic filtering options for time periods (LTM/YTD), brands, and client types.
- Detailed analysis of:
  - Sales trends by size and client type.
  - Net sales and gross profit performance over time.
- Intuitive dashboard design for quick, actionable insights.

---

## **Technologies and Tools**
- **Excel**:  
  Used for data preparation, pivot tables, formulas, and dashboard creation.  
  Key functions: `IFERROR`, `VLOOKUP`, `SUM`.
  
- **Tableau**:  
  Created additional dashboards for advanced visualizations and dynamic insights.

---

## **Dashboard Snapshots**

### **1. Excel Dashboard**
![Soft Drinks Excel Dashboard](https://github.com/user-attachments/assets/888eefb7-ddc1-47ea-8432-bb9fbb6db64b)

### **2. Tableau Dashboard**
![Soft Drinks Tableau Dashboard](https://github.com/user-attachments/assets/62686f92-73ba-4ec8-909a-459cc8562812)

---

## **Conclusion**
This project successfully demonstrates how raw sales data can be transformed into actionable business intelligence through well-structured processes and professional dashboard design. The final dashboard allows stakeholders to analyze sales trends interactively, identify growth opportunities, and make informed decisions.
