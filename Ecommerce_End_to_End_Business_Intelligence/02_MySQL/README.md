# E-Commerce Business Intelligence & Customer Analytics — SQL Project

## Overview
This MySQL project explores raw e-commerce data, prepares cleaned analytical tables, validates data quality and relationships, and investigates sales, profitability, customer behaviour, cohort retention, RFM segments, Pareto contribution and discount-related Furniture losses.

## Project structure

```text
Ecommerce_SQL_Project/
├── 01_Database_Setup/
│   └── 01_database_and_raw_tables.sql
├── 02_Data_Profiling/
│   └── 02_raw_data_exploration.sql
├── 03_Data_Cleaning/
│   └── 03_data_cleaning.sql
├── 04_Data_Validation/
│   └── 04_data_validation.sql
├── 05_Business_Analysis/
│   └── 05_business_analysis_and_investigation.sql
├── 06_Documentation/
│   └── SQL_PROJECT_NOTES.md
└── README.md
```

## Data import workflow
The source CSV data was loaded into MySQL Workbench using **Table Data Import Wizard**. The SQL scripts create the database and the three raw table structures; they do not contain `LOAD DATA` statements or automated CSV import commands.

Import the matching CSV files into these tables after running the database setup script:
- `customers_raw` ← Customers CSV
- `products_raw` ← Products CSV
- `orders_raw` ← Orders CSV

Use the same column order and compatible data types as the table definitions. Confirm the imported row counts before moving to profiling. The supplied SQL source does not define `returns_raw` or include returns-analysis queries, so returns are not claimed as part of this SQL deliverable.

## Recommended execution order
1. Open MySQL Workbench and connect to your MySQL server.
2. Run `01_Database_Setup/01_database_and_raw_tables.sql`. This creates the schema and raw table structures.
3. Use **Table Data Import Wizard** to import the three CSVs into `customers_raw`, `products_raw` and `orders_raw`.
4. Verify that each raw table contains the expected number of rows.
5. Run `02_Data_Profiling/02_raw_data_exploration.sql`.
6. Run `03_Data_Cleaning/03_data_cleaning.sql`.
7. Run `04_Data_Validation/04_data_validation.sql` and inspect the returned checks.
8. Run `05_Business_Analysis/05_business_analysis_and_investigation.sql`.

Run the scripts in this order. The cleaning script uses `CREATE TABLE` statements and is not designed to be rerun unchanged against an already-cleaned database. For a fresh full rerun, use a fresh/reset project schema and reimport the source CSVs.

## Data model included in this SQL package
- `customers_raw` → `customers_clean`
- `products_raw` → `products_clean`
- `orders_raw` → `orders_clean`

## Query documentation
Each executable SQL statement has a `-- PURPOSE:` comment explaining what it is intended to check, create or calculate. Existing section headings and original query logic are retained.

## Scope and verification note
This package is organized from the SQL script supplied for this project. The queries have not been executed against your local MySQL instance in this packaging step. Test each folder in order and check the actual result sets and row counts before publishing the repository as execution-verified.

Keep the raw dataset files in the repository only if you have permission to redistribute them and they contain no personal or confidential information.