{{ config(materialized='table', schema='data_mart') }}

with order_ranked as (

    select
        o.order_hk,
        loc.customer_hk,
        lor.restaurant_hk,

        s.order_date,
        s.order_status,
        s.order_type,
        s.total_amount,
        s.delivery_fee,
        s.service_fee,
        s.currency,

        row_number() over (
            partition by o.order_hk
            order by s.order_date desc
        ) as rn

    from {{ ref('hub_order') }} o

    left join {{ ref('sat_order') }} s
        on o.order_hk = s.order_hk

    left join {{ ref('link_order_customer') }} loc
        on o.order_hk = loc.order_hk

    left join {{ ref('link_order_restaurant') }} lor
        on o.order_hk = lor.order_hk

),

payment_ranked as (

    select
        lop.order_hk,
        sop.payment_method,
        sop.payment_status,
        sop.payment_date,
        sop.amount as payment_amount,

        row_number() over (
            partition by lop.order_hk
            order by sop.dv_load_date desc
        ) as rn

    from {{ ref('link_order_payment') }} lop

    left join {{ ref('sat_order_payment') }} sop
        on lop.order_payment_hk = sop.order_payment_hk

)

select
    oo.order_hk,
    oo.customer_hk,
    oo.restaurant_hk,

    oo.order_date,
    oo.order_status,
    oo.order_type,
    oo.total_amount,
    oo.delivery_fee,
    oo.service_fee,
    oo.currency,

    pp.payment_method,
    pp.payment_status,
    pp.payment_date,
    pp.payment_amount

from order_ranked oo

left join payment_ranked pp
    on oo.order_hk = pp.order_hk
    and pp.rn = 1

where oo.rn = 1