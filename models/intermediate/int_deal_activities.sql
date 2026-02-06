{{
    config(
        materialized='view'
    )
}}

select
    a.activity_id,
    a.deal_id,
    a.activity_type_key,
    at.activity_type_name,
    a.assigned_user_id,
    a.is_done,
    a.due_at as activity_timestamp,
    case
        when a.activity_type_key = 'meeting' then '2.1'
        when a.activity_type_key = 'sc_2' then '3.1'
        else null
    end as funnel_step,
    case
        when a.activity_type_key = 'meeting' then 'Sales Call 1'
        when a.activity_type_key = 'sc_2' then 'Sales Call 2'
        else null
    end as kpi_name
from {{ ref('stg_activity') }} a
left join {{ ref('stg_activity_types') }} at 
    on a.activity_type_key = at.activity_type_key
where a.activity_type_key in ('meeting', 'sc_2')
