{{ config(materialized='table', schema='data_mart') }}

with ranked as (

    select
        sd.dish_hk,
        ldr.restaurant_hk,

        sd.dish_name,
        sd.dish_category,
        sd.cuisine_type,
        sd.unit_price,
        sd.preparation_time_minutes,
        sd.calories,
        sd.is_available,
        sd.dv_load_date,

        row_number() over (
            partition by sd.dish_hk
            order by sd.dv_load_date desc
        ) as rn

    from {{ ref('sat_dish') }} sd
    left join {{ ref('link_dish_restaurant') }} ldr
        on sd.dish_hk = ldr.dish_hk

)

select
    dish_hk,
    restaurant_hk,
    dish_name,
    dish_category,
    cuisine_type,
    unit_price,
    preparation_time_minutes,
    calories,
    is_available

from ranked
where rn = 1