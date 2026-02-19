-- Pulling the actuals data
monthly_actuals as (
	select
		transactions.cost_centre_id as T_cost_centre_id,
		date_trunc('month',transaction_date)::date as T_month,
		sum(transaction_amount) as monthly_actuals_amount,
		sum(
			case
				when dim_cost_centres.centre_type = 'Cost' then -1 * coalesce(transactions.transaction_amount,0)
				when dim_cost_centres.centre_type = 'Revenue' then coalesce(transactions.transaction_amount,0)
				else transactions.transaction_amount
			end
		) as monthly_actuals_fpa
	from transactions
	inner join dim_cost_centres
		on transactions.cost_centre_id = dim_cost_centres.cost_centre_id
	group by
		transactions.cost_centre_id,
		T_month
),
