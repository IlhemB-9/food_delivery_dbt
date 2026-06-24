{{ config(materialized='table', schema='data_vault') }}

select distinct
    md5(trim(lower(order_id::text))) as order_hk,
    order_id,

    current_timestamp as dv_load_date,
    'staging.stg_orders' as record_source
from {{ source('staging','stg_orders') }}
where customer_id is not null
