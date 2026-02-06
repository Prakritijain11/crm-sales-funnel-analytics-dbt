{{
    config(
        materialized='view'
    )
}}

with stage_changes as (
    select
        deal_id,
        changed_at as entered_stage_at,
        cast(new_value as integer) as stage_id
    from {{ ref('stg_deal_changes') }}
    where changed_field_key = 'stage_id'
),

deal_creations as (
    select
        deal_id,
        changed_at as entered_stage_at,
        1 as stage_id
    from {{ ref('stg_deal_changes') }}
    where changed_field_key = 'add_time'
)

select
    coalesce(sc.deal_id, dc.deal_id) as deal_id,
    coalesce(sc.entered_stage_at, dc.entered_stage_at) as entered_stage_at,
    coalesce(sc.stage_id, dc.stage_id) as stage_id,
    s.stage_name,
    cast(coalesce(sc.stage_id, dc.stage_id) as varchar) as funnel_step,
    s.stage_name as kpi_name
from stage_changes sc
full outer join deal_creations dc 
    on sc.deal_id = dc.deal_id 
    and sc.stage_id = 1
left join {{ ref('stg_stages') }} s 
    on coalesce(sc.stage_id, dc.stage_id) = s.stage_id
where coalesce(sc.stage_id, dc.stage_id) is not null
