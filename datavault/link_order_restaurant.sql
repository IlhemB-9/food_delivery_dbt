{{ config(materialized='table', schema='data_vault') }}

select distinct

    md5(
        coalesce(trim(lower(order_id::text)),'') || '|' ||
        coalesce(trim(lower(restaurant_id::text)),'')
    ) as link_order_restaurant_hk,

    md5(trim(lower(order_id::text))) as order_hk,
    md5(trim(lower(restaurant_id::text))) as restaurant_hk,

    current_timestamp as load_date,
    'staging.stg_orders' as record_source

from {{ source('staging','stg_orders') }}

where order_id is not null
  and restaurant_id is not null