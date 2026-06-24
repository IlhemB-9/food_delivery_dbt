{{ config(materialized='table', schema='data_vault') }}

select

    md5(
        coalesce(trim(lower(order_id::text)),'') || '|' ||
        coalesce(trim(lower(dish_id::text)),'')
    ) as link_order_dish_hk,

    quantity,
    unit_price,
    special_instructions,
    line_total,

    md5(
        coalesce(quantity::text,'') || '|' ||
        coalesce(unit_price::text,'') || '|' ||
        coalesce(special_instructions,'') || '|' ||
        coalesce(line_total::text,'')
    ) as hashdiff,

    current_timestamp as dv_load_date,
    'staging.stg_order_lines' as record_source

from {{ source('staging','stg_order_lines') }}