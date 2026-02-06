{{
    config(
        materialized='table'
    )
}}

with stage_events as (
    select
        deal_id,
        entered_stage_at as event_timestamp,
        funnel_step,
        kpi_name,
        'stage_transition' as event_type
    from {{ ref('int_deal_stage_history') }}
    where funnel_step is not null
),

activity_events as (
    select
        deal_id,
        activity_timestamp as event_timestamp,
        funnel_step,
        kpi_name,
        'activity' as event_type
    from {{ ref('int_deal_activities') }}
    where funnel_step is not null
      and deal_id is not null
)

select * from stage_events
union all
select * from activity_events
