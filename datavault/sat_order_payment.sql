{{ config(materialized='table', schema='data_vault') }}

select

    md5(
        coalesce(trim(lower(order_id::text)),'') || '|' ||
        coalesce(trim(lower(payment_id::text)),'')
    ) as order_payment_hk,

    payment_method,
    payment_status,
    payment_date,
    amount,
    currency,
    transaction_id,

    md5(
        coalesce(payment_method,'') || '|' ||
        coalesce(payment_status,'') || '|' ||
        coalesce(payment_date::text,'') || '|' ||
        coalesce(amount::text,'') || '|' ||
        coalesce(currency,'') || '|' ||
        coalesce(transaction_id,'')
    ) as hashdiff,

    current_timestamp as dv_load_date,
    'staging.stg_payments' as record_source

from {{ source('staging','stg_payments') }}