-- Consolidating the data
consolidated_monthly_facts as (
	select
		calendar_cost_centre_id as cost_centre_id,
		calendar_month as month,
		department,
		centre_type as cost_centre_type,
		coalesce(monthly_budget_amount,0) as monthly_budget_amount,
		coalesce(monthly_actuals.monthly_actuals_amount,0) as monthly_actuals_amount,
		coalesce(monthly_actuals_fpa,0) as monthly_actuals_fpa
	from calendar_month
	left join monthly_budgets
		on calendar_cost_centre_id = monthly_budgets.b_cost_centre_id
		and calendar_month = monthly_budgets.b_month
	left join monthly_actuals
		on calendar_cost_centre_id = monthly_actuals.T_cost_centre_id
		and calendar_month = monthly_actuals.T_month
	left join dim_cost_centres
		on calendar_cost_centre_id = dim_cost_centres.cost_centre_id
),
