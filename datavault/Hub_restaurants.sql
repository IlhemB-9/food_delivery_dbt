{{ config(materialized='table', schema='data_vault') }}

select distinct
    md5(trim(lower(restaurant_id::text))) as restaurant_hk,
    restaurant_id,

    current_timestamp as dv_load_date,
    'staging.stg_restaurants' as record_source
from {{ source('staging','stg_restaurants') }}
where customer_id is not null
