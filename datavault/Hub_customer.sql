{{ config(materialized='table', schema='data_vault') }}

select distinct
    md5(trim(lower(customer_id::text))) as customer_hk,
    customer_id,

    current_timestamp as dv_load_date,
    'staging.stg_customers' as record_source
from {{ source('staging','stg_customers') }}
where customer_id is not null
