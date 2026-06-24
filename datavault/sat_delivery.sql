{{ config(materialized='table', schema='data_mart') }}

with ranked as (

    select
        sd.delivery_hk,
        ldo.order_hk,
        ldr.restaurant_hk,
        ldd.driver_hk,

        sd.pickup_time,
        sd.planned_delivery_time,
        sd.actual_delivery_time,
        sd.delivery_status,
        sd.delivery_fee,
        sd.distance_km,
        sd.customer_rating,
        sd.dv_load_date,

        row_number() over (
            partition by sd.delivery_hk
            order by sd.dv_load_date desc
        ) as rn

    from {{ ref('sat_delivery') }} sd
    left join {{ ref('link_delivery_order') }} ldo on sd.delivery_hk = ldo.delivery_hk
    left join {{ ref('link_delivery_restaurant') }} ldr on sd.delivery_hk = ldr.delivery_hk
    left join {{ ref('link_delivery_driver') }} ldd on sd.delivery_hk = ldd.delivery_hk

)

select
    delivery_hk,
    order_hk,
    restaurant_hk,
    driver_hk,
    pickup_time,
    planned_delivery_time,
    actual_delivery_time,
    delivery_status,
    delivery_fee,
    distance_km,
    customer_rating

from ranked
where rn = 1