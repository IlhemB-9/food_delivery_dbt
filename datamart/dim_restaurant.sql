{{ config(materialized='table', schema='data_mart') }}

with ranked as (

    select
        restaurant_hk,
        restaurant_name,
        cuisine_type,
        country,
        city,
        address,
        rating,
        manager_name,
        phone_number,
        load_date,

        row_number() over (
            partition by restaurant_hk
            order by load_date desc
        ) as rn

    from {{ ref('sat_restaurant') }}

)

select
    restaurant_hk,
    restaurant_name,
    cuisine_type,
    country,
    city,
    address,
    rating,
    manager_name,
    phone_number

from ranked
where rn = 1
