{{ config(materialized='table', schema='data_vault') }}

select distinct
    md5(
        coalesce(trim(lower(order_id::text)),'') || '|' ||
        coalesce(trim(lower(payment_id::text)),'')
    ) as link_order_payment_hk,

    md5(trim(lower(order_id::text))) as order_hk,
    md5(trim(lower(payment_id::text))) as payment_hk,

    current_timestamp as load_date,
    'staging.stg_payments' as record_source

from {{ source('staging','stg_payments') }}
where order_id is not null
  and payment_id is not null