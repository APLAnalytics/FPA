--Pulling cost centre info for reference
with
	dim_cost_centres as (
	select
		cost_centre_id,
		department,
		centre_type
	from cost_centres
),
