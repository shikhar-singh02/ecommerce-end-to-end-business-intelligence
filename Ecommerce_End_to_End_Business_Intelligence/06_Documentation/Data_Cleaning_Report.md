# Data Cleaning Report

## Scope
The cleaning work covers the Orders, Customers, and Products data used in the e-commerce analysis. The original raw files are kept separately from the cleaned outputs.

## Issues Identified in the Orders Data
The profiling notes recorded the following issues before cleaning:

| Issue | Records reported |
|---|---:|
| Duplicate rows identified (including records requiring review) | 50 |
| Confirmed real duplicates within those duplicate candidates | 25 |
| Invalid order dates (31/13/2024) | 68 |
| Blank customer names | 118 |
| Blank email values | 144 |
| Blank phone values | 81 |
| City formatting inconsistencies (case/leading spaces) | 167 |
| Region formatting inconsistencies (case/leading spaces) | 190 |
| Blank Product_ID values | 149 |
| Quantity equal to zero | 273 |
| Quantity below zero | 256 |
| Quantity stored as text | 104 |
| Unit price values containing a rupee symbol | 88 |
| Blank Sales values | 79 |
| Negative Sales values | 532 |
| Sales equal to zero | 273 |
| Blank Discount values | 592 |
| Discount below zero | 275 |
| Discount above one | 359 |
| Ship_Mode text in inconsistent lowercase | 92 |
| Inconsistent Order_Status text (Delivered) | 78 |
| Sales_Channel text inconsistency (website) | 49 |
| Return flag values stored as text | 46 |
| Notes values requiring text-format review | 41 |
| Blank Notes values | 24,959 |
| Ship date earlier than order date (excluding invalid order dates) | 64 |
| Customer_ID values not found in the Customers table | 37 |
| Product_ID values missing from the Products table (excluding blank Product_ID values) | 26 |
| Return_ID values not found in the Returns table | 19 |

## Cleaning Approach Documented in the SQL Project
- Standardise inconsistent text values and formatting.
- Review and handle duplicate records, including conflicting duplicate cases.
- Exclude invalid transaction records according to the cleaning logic in the SQL script.
- Handle invalid date relationships, including ship dates earlier than order dates.
- Validate customer and product references against their respective tables.
- Retain negative profit values where they represent business outcomes rather than data-entry errors.

## Important Notes
- The counts above are the issues reported during the project's profiling stage; they are not a claim that every issue has the same treatment or that all counts are mutually exclusive.
- The supplied SQL project contains raw and clean Customers, Products, and Orders workflows. The separate Returns table checks mentioned in the broader workbook profiling are not implemented as a Returns SQL workflow in the supplied SQL package.
- Use the SQL validation queries and the final cleaned CSV files to confirm the final record counts before publishing numerical claims.
