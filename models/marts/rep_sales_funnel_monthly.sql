{{
    config(
        materialized='table'
    )
}}

with funnel_events as (
    select
        date_trunc('month', event_timestamp) as month,
        funnel_step,
        kpi_name,
        deal_id
    from {{ ref('fct_deal_funnel_events') }}
    where event_timestamp is not null
),

aggregated as (
    select
        month,
        kpi_name,
        funnel_step,
        count(distinct deal_id) as deals_count
    from funnel_events
    group by month, kpi_name, funnel_step
)

select
    month,
    kpi_name,
    funnel_step,
    deals_count
from aggregated
order by month, 
    case 
        when funnel_step = '1' then 1.0
        when funnel_step = '2' then 2.0
        when funnel_step = '2.1' then 2.1
        when funnel_step = '3' then 3.0
        when funnel_step = '3.1' then 3.1
        when funnel_step = '4' then 4.0
        when funnel_step = '5' then 5.0
        when funnel_step = '6' then 6.0
        when funnel_step = '7' then 7.0
        when funnel_step = '8' then 8.0
        when funnel_step = '9' then 9.0
        else 99.0
    end
