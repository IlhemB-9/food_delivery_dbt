{{ config(materialized='table', schema='data_vault') }}

select
    md5(trim(lower(restaurant_id::text))) as restaurant_hk,

    restaurant_name,
    cuisine_type,
    country,
    city,
    address,
    rating,
    manager_name,
    phone_number,

    md5(
        coalesce(restaurant_name,'') || '|' ||
        coalesce(cuisine_type,'') || '|' ||
        coalesce(country,'') || '|' ||
        coalesce(city,'') || '|' ||
        coalesce(address,'') || '|' ||
        coalesce(manager_name,'') || '|' ||
        coalesce(phone_number,'') || '|' ||
        coalesce(rating::text,'')
    ) as hashdiff,

    current_timestamp as dv_load_date,
    'staging.stg_restaurants' as record_source

from {{ source('staging','stg_restaurants') }}