{{ config(materialized='table', schema='data_vault') }}

select

    md5(trim(lower(order_id::text))) as order_hk,

    order_date,
    order_status,
    order_type,
    total_amount,
    delivery_fee,
    service_fee,
    currency,

    md5(
        coalesce(order_date::text,'') || '|' ||
        coalesce(order_status,'') || '|' ||
        coalesce(order_type,'') || '|' ||
        coalesce(total_amount::text,'') || '|' ||
        coalesce(delivery_fee::text,'') || '|' ||
        coalesce(service_fee::text,'') || '|' ||
        coalesce(currency,'')
    ) as hashdiff,

    current_timestamp as dv_load_date,
    'staging.stg_orders' as record_source

from {{ source('staging','stg_orders') }}