{{ config(materialized='table', schema='data_vault') }}

select distinct

    md5(
        coalesce(trim(lower(order_id::text)),'') || '|' ||
        coalesce(trim(lower(dish_id::text)),'')
    ) as link_order_dish_hk,

    md5(trim(lower(order_id::text))) as order_hk,
    md5(trim(lower(dish_id::text))) as dish_hk,

    current_timestamp as load_date,
    'staging.stg_order_lines' as record_source

from {{ source('staging','stg_order_lines') }}
where order_id is not null
  and dish_id is not null