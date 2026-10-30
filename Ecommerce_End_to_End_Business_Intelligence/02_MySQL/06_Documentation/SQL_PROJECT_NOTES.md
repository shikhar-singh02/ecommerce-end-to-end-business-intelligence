# SQL Project Notes

## Workflow
1. Create the database and raw table structures.
2. Import Customers, Products and Orders CSV files through MySQL Workbench **Table Data Import Wizard**.
3. Profile the raw data.
4. Build the cleaned customer, product and order tables.
5. Run validation checks.
6. Run business analysis and the Furniture high-discount investigation.

## Table Data Import Wizard mapping
- Customers CSV → `customers_raw`
- Products CSV → `products_raw`
- Orders CSV → `orders_raw`

## Cleaning logic documented in the supplied SQL
- Trim and standardize selected text fields.
- Convert empty descriptive values to NULL where specified.
- Remove exact duplicate order rows.
- Resolve the specifically documented conflicting duplicate records.
- Exclude zero-quantity, negative-sales and discount-above-100-percent transactions from `orders_clean`.
- Convert invalid ship dates (earlier than order dates) to NULL.
- Retain negative profit values intentionally for loss analysis.

## Important execution caution
`CREATE TABLE` statements will fail if the target tables already exist. Run the scripts in sequence on a fresh/reset schema for a clean end-to-end test. Review every validation result rather than assuming that a query returning zero rows is automatically a failure.

## Source fidelity
The SQL logic is preserved from the supplied source script. Purpose comments are added to explain each executable statement; comments do not change query behaviour.