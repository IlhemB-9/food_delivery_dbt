{{ config(materialized='table', schema='data_vault') }}

select distinct

    md5(
        coalesce(trim(lower(dish_id::text)),'') || '|' ||
        coalesce(trim(lower(restaurant_id::text)),'')
    ) as link_dish_restaurant_hk,

    md5(trim(lower(dish_id::text))) as dish_hk,
    md5(trim(lower(restaurant_id::text))) as restaurant_hk,

    current_timestamp as load_date,
    'staging.stg_dishes' as record_source

from {{ source('staging','stg_dishes') }}
where dish_id is not null
  and restaurant_id is not null