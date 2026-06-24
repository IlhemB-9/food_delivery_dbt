{{ config(materialized='table', schema='data_vault') }}

select

    md5(trim(lower(dish_id::text))) as dish_hk,

    dish_name,
    dish_category,
    cuisine_type,
    unit_price,
    preparation_time_minutes,
    calories,
    is_available,

    md5(
        coalesce(dish_name,'') || '|' ||
        coalesce(dish_category,'') || '|' ||
        coalesce(cuisine_type,'') || '|' ||
        coalesce(unit_price::text,'') || '|' ||
        coalesce(preparation_time_minutes::text,'') || '|' ||
        coalesce(calories::text,'') || '|' ||
        coalesce(is_available::text,'')
    ) as hashdiff,

    current_timestamp as dv_load_date,
    'staging.stg_dishes' as record_source

from {{ source('staging','stg_dishes') }}