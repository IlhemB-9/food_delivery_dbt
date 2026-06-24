{{ config(materialized='table', schema='data_vault') }}

select distinct
    md5(trim(lower(dish_id::text))) as dish_hk,
    dish_id,

    current_timestamp as dv_load_date,
    'staging.stg_dishes' as record_source
from {{ source('staging','stg_dishes') }}
where customer_id is not null
