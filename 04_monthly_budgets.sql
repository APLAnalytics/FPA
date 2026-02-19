-- Pulling the budget data
monthly_budgets as (
	select
		budgets.cost_centre_id as b_cost_centre_id,
		month as b_month,
		sum(budget_amount) as monthly_budget_amount
	from budgets
	group by
		budgets.cost_centre_id,
		month
),