# Project Methodology

## Project Overview
This project analyses an e-commerce business using MySQL, Python, Excel, and Power BI. The work is organised as an end-to-end workflow, from raw data inspection and cleaning to business analysis and dashboard reporting.

## Data Sources and Structure
The project uses three core data tables:
- **Orders** – transaction-level order details, including dates, customer and product identifiers, quantity, sales, discount, profit, shipping, and payment information.
- **Customers** – customer details and attributes such as segment and geography.
- **Products** – product names, categories, and sub-categories.

The raw and cleaned datasets are kept separately. The original raw files are preserved, while cleaned files are used for analysis.

## Workflow
1. **Data preparation:** Preserve the original files and organise raw and cleaned datasets separately.
2. **SQL database setup:** Create the database and raw tables in MySQL.
3. **Data import:** Import the Customers, Products, and Orders CSV files into their respective raw tables using MySQL Workbench's Table Data Import Wizard.
4. **Data profiling:** Inspect record counts, missing values, duplicates, inconsistent text, invalid dates, and relationship issues.
5. **Data cleaning:** Standardise fields and prepare clean customer, product, and order tables. Business-valid negative profit values are retained rather than automatically treated as invalid.
6. **Data validation:** Check cleaned record counts, key uniqueness, and customer/product relationships.
7. **Business analysis:** Analyse sales, profitability, products, customers, retention, RFM segments, geography, shipping, discounts, and other business questions.
8. **Reporting:** Present findings through a Python notebook, Excel dashboard, and five-page Power BI dashboard.

## Tools Used
- **MySQL:** Database setup, profiling, cleaning, validation, and business queries.
- **Python:** Jupyter Notebook analysis using Python data-analysis and visualisation libraries.
- **Microsoft Excel:** Business analysis and an interactive executive dashboard.
- **Power BI:** Interactive dashboards for executive, sales, customer, regional/operations, and customer-retention analysis.

## Reproducibility Notes
- Import the raw CSV files into the raw tables before running the profiling and cleaning scripts.
- Run the SQL files in the documented sequence in the SQL project README.
- The SQL scripts have been tested by the project author in MySQL Workbench.
- The Python notebook may require its dependencies to be installed and its dataset paths to be set to the local folder structure.
