# FP&A Finance Dataset

This repo contains a mini FP&A-style dataset built in PostgreSQL using modular SQL scripts.
The output is a BI-ready table suitable for Tableau reporting.

## What this project demonstrates
- Building a month spine (date spine) at a defined grain: (cost_centre_id, month)
- Monthly actuals + budgets aggregation
- Cost vs Revenue logic using centre_type
- YTD metrics using window functions (resetting by year where needed)
- Sanity checks to prevent duplication at the grain

## Scripts (run order)
1. `01_dimension_cost_centres.sql`
2. `02_calendar_spine.sql`
3. `03_monthly_actuals.sql`
4. `04_monthly_budgets.sql`
5. `05_consolidated_monthly_facts.sql`
6. `06_ytd_logic.sql`
7. `07_final_metrics.sql`
8. `data_validation_checks.sql`

## Output
The final dataset includes:
- monthly + YTD budget/actuals
- favourable variance (cost + revenue standardised)
- vs-budget percentages
- boolean flags (current month / latest month in data)
