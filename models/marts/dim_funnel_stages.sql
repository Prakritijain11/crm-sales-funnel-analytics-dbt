{{
    config(
        materialized='table'
    )
}}

with pipeline_stages as (
    select
        stage_id as funnel_step_id,
        cast(stage_id as varchar) as funnel_step,
        stage_name as kpi_name,
        stage_id as sort_order
    from {{ ref('stg_stages') }}
),

activity_steps as (
    select
        100 + row_number() over (order by activity_type_key) as funnel_step_id,
        case
            when activity_type_key = 'meeting' then '2.1'
            when activity_type_key = 'sc_2' then '3.1'
        end as funnel_step,
        case
            when activity_type_key = 'meeting' then 'Sales Call 1'
            when activity_type_key = 'sc_2' then 'Sales Call 2'
        end as kpi_name,
        case
            when activity_type_key = 'meeting' then 2.1
            when activity_type_key = 'sc_2' then 3.1
        end as sort_order
    from {{ ref('stg_activity_types') }}
    where activity_type_key in ('meeting', 'sc_2')
)

select * from pipeline_stages
union all
select * from activity_steps
order by sort_order
