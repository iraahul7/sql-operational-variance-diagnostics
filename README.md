# Relational Database Extraction & Operational Variance Diagnostics

**Tech Stack:** SQL (CTEs, Window Functions, Complex Joins, Audit Views) | Python SQLite Audit Runner

## Project Overview
Engineered modular SQL queries and audit-ready views across **75,000+ transactional records** to isolate **18% operational variance anomalies** and reduce manual spreadsheet lookups by **50%**.

![Operational Variance Anomalies by Vendor](images/operational_variance_anomalies.png)

## Repository Structure
```text
|-- notebooks/
|   |-- 01_sql_variance_diagnostics_demo.ipynb  # Executed SQLite notebook running CTE variance queries
|-- sql/
|   |-- 01_audit_views_schema.sql               # Consolidates 75,000+ records into standardized audit views
|   |-- 02_operational_variance_audit.sql       # CTEs & window functions isolating 18% variance anomalies
|-- scripts/
|   |-- run_sqlite_audit.py                     # Standalone executable script testing the SQL queries locally
|-- images/
|   |-- operational_variance_anomalies.png      # Vendor billing variance chart
|-- README.md
```
