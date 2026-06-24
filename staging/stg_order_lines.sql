{{ config(materialized='view', schema='staging') }}

select *
from {{ source('staging', 'stg_order_lines') }}
Hub Customer : 

{{ config(materialized='table', schema='data_vault') }}

select distinct
    md5(trim(lower(customer_id::text))) as customer_hk,
    customer_id,

    current_timestamp as dv_load_date,
    'staging.stg_order_lines' as record_source
from {{ source('staging','stg_order_lines') }}
where customer_id is not null
