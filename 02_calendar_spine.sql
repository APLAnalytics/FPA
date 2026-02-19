
-- Creating calendar months
calendar_month as (
	select
		cost_centre_id as calendar_cost_centre_id,
		generate_series('2024-01-01','2025-12-01', interval '1 month')::date as calendar_month
	from dim_cost_centres
),