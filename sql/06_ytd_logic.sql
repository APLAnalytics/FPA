-- Creating YTD data
ytd_budget_actuals as (
	select
		cost_centre_id,
		month,
			coalesce(sum(monthly_budget_amount) over (
			partition by cost_centre_id, date_trunc('year', month)
			order by month
			rows between unbounded preceding and current row
			),0) as ytd_budget,
		coalesce(sum(monthly_actuals_fpa) over (
			partition by cost_centre_id, date_trunc('year', month)
			order by month
			rows between unbounded preceding and current row
			),0) as ytd_actuals
	from consolidated_monthly_facts
),
