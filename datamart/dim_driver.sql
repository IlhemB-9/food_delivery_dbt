{{ config(materialized='table', schema='data_mart') }}

with ranked as (

    select
        h.driver_hk,
        h.driver_id,
        s.driver_first_name,
        s.driver_last_name,
        s.driver_phone,
        s.driver_rating,
        s.dv_load_date,

        row_number() over (
            partition by h.driver_hk
            order by s.dv_load_date desc
        ) as rn

    from {{ ref('hub_driver') }} h
    left join {{ ref('sat_driver') }} s
        on h.driver_hk = s.driver_hk

)

select
    driver_hk,
    driver_id,
    driver_first_name,
    driver_last_name,
    driver_first_name || ' ' || driver_last_name as driver_full_name,
    driver_phone,
    driver_rating

from ranked
where rn = 1