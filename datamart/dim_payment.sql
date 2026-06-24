{{ config(materialized='table', schema='data_mart') }}

select
    payment_hk,
    payment_method,
    payment_status,
    payment_date,
    amount,
    currency,
    transaction_id

from {{ ref('sat_payment') }}