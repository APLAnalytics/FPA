-- Checking the months range from Jan 2024 - Dec 2025
select
	cost_centre_id, 
	min(date_trunc('month',t.transaction_date)::date) as min_month,
	max(date_trunc('month',t.transaction_date)::date) as max_month
from transactions t
group by
	cost_centre_id
order by
	cost_centre_id,
	min_month;

-- Checking all cost centres have 24 months
with calendar_month as (
	select
	generate_series('2024-01-01','2025-12-01', interval '1 month')::date as month
	)
select
	cost_centre_id,
	count(*) as months_per_cc
from cost_centres
cross join calendar_month
group by
	cost_centre_id
order by
	cost_centre_id;

-- Checking the grain at cost centre and month level. No results should be present.
with monthly_actuals as (
	select
		transactions.cost_centre_id,
		date_trunc('month',transaction_date)::date as month,
		sum(transaction_amount) as T_monthly_amount
	from transactions
	group by
		transactions.cost_centre_id,
		month
)
select 
	cost_centre_id,
	month,
	count(*) as duplicate_rows
from monthly_actuals
group by 
	cost_centre_id,
	month
having 
count(*) > 1
order by
	cost_centre_id,
	month;

-- Checking the grain at cost centre and month level. No results should be present.
with monthly_budgets as (
	select
		budgets.cost_centre_id,
		month,
		sum(budget_amount) as monthly_budget
	from budgets
	group by
		budgets.cost_centre_id,
		month
)
select
	cost_centre_id,
	month,
	count(*) as duplicate_rows
from monthly_budgets
group by
	cost_centre_id,
	month
having 
count(*) > 1
order by
	cost_centre_id,
	month;