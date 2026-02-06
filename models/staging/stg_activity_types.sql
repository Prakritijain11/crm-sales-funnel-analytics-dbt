{{
    config(
        materialized='view'
    )
}}

select
    id as activity_type_id,
    name as activity_type_name,
    type as activity_type_key,
    case 
        when upper(active) = 'YES' then true
        else false
    end as is_active
from {{ source('pipedrive', 'activity_types') }}
