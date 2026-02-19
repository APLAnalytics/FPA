-- FINAL OUTPUT:
-- Grain: 1 row per (cost_centre_id, month)
-- Definitions:
--   variance_fpa: favourable when positive (both cost + revenue)
--   ytd_vs_budget_pct: progress vs target (revenue) / budget remaining (cost)
final_metrics as (
	select
	-- current_month: will only work when dataset includes the real current month
	case
		when consolidated_monthly_facts.month = date_trunc('month',current_date) then true
		else false
		end	
	as system_current_month,
	case 
  		when consolidated_monthly_facts.month = max(consolidated_monthly_facts.month) over () then true
  		else false
		end 
	as latest_month_in_data,
	extract(year from consolidated_monthly_facts.month) as year,
	extract(month from consolidated_monthly_facts.month) as month_number,
	consolidated_monthly_facts.cost_centre_id,
	consolidated_monthly_facts.department,
	consolidated_monthly_facts.month,
	consolidated_monthly_facts.cost_centre_type,
	monthly_budget_amount,
	monthly_actuals_fpa,
	case
			when consolidated_monthly_facts.cost_centre_type = 'Cost' then monthly_budget_amount - monthly_actuals_fpa
			when consolidated_monthly_facts.cost_centre_type = 'Revenue' then monthly_actuals_fpa - monthly_budget_amount
			else monthly_budget_amount - monthly_actuals_fpa
		end
	as monthly_variance_fpa,
	case
			when monthly_budget_amount = 0 then 0
			when consolidated_monthly_facts.cost_centre_type = 'Cost' then 1 - monthly_actuals_fpa / nullif(monthly_budget_amount,0)
			when consolidated_monthly_facts.cost_centre_type = 'Revenue' then (monthly_actuals_fpa - monthly_budget_amount) / nullif(monthly_budget_amount,0)
			else 1 - monthly_actuals_fpa / nullif(monthly_budget_amount,0)
		end
	as month_vs_budget_pct,
	ytd_budget,
	ytd_actuals,
	case
			when consolidated_monthly_facts.cost_centre_type = 'Cost' then ytd_budget - ytd_actuals
			when consolidated_monthly_facts.cost_centre_type = 'Revenue' then ytd_actuals - ytd_budget
			else ytd_budget - ytd_actuals
		end
	as ytd_variance_fpa,
	case
			when ytd_budget = 0 then 0
			when consolidated_monthly_facts.cost_centre_type = 'Cost' then 1 - ytd_actuals / nullif(ytd_budget,0)
			when consolidated_monthly_facts.cost_centre_type = 'Revenue' then (ytd_actuals - ytd_budget) / nullif(ytd_budget,0)
			else 1 - ytd_actuals / nullif(ytd_budget,0)
		end
	as ytd_vs_budget_pct
from consolidated_monthly_facts
left join ytd_budget_actuals
	on consolidated_monthly_facts.cost_centre_id = ytd_budget_actuals.cost_centre_id
	and consolidated_monthly_facts.month = ytd_budget_actuals.month
)
select *
from final_metrics;