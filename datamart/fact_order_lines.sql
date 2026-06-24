{{ config(materialized='table', schema='data_mart') }}

with lines_ranked as (

    select
        lod.order_hk,
        lod.dish_hk,

        sod.quantity,
        sod.unit_price,
        sod.special_instructions,
        sod.line_total,

        row_number() over (
            partition by lod.link_order_dish_hk
            order by sod.dv_load_date desc
        ) as rn

    from {{ ref('link_order_dish') }} lod

    left join {{ ref('sat_order_dish') }} sod
        on lod.link_order_dish_hk = sod.link_order_dish_hk

)

select
    order_hk,
    dish_hk,
    quantity,
    unit_price,
    special_instructions,
    line_total

from lines_ranked
where rn = 1