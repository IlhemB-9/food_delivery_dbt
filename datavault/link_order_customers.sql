{{ config(materialized='table', schema='data_vault') }}

select distinct

    md5(trim(lower(order_id::text))) as order_hk,
    md5(trim(lower(customer_id::text))) as customer_hk,

    current_timestamp as load_date,
    'stg_orders' as record_source

from {{ source('staging','stg_orders') }}

where order_id is not null
  and customer_id is not null
