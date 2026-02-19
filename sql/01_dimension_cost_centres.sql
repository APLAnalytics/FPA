with 
--Pulling cost centre info for reference
dim_cost_centres as (
	select
		cost_centre_id,
		department,
		centre_type
	from cost_centres
),
