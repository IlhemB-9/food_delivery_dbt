{{ config(materialized='table', schema='data_vault') }}

select distinct
    md5(trim(lower(driver_id::text))) as driver_hk,

    driver_first_name,
    driver_last_name,
    driver_phone,
    driver_rating,

    md5(
        coalesce(driver_first_name,'') || '|' ||
        coalesce(driver_last_name,'') || '|' ||
        coalesce(driver_phone,'') || '|' ||
        coalesce(driver_rating::text,'')
    ) as hashdiff,

    current_timestamp as dv_load_date,
    'staging.stg_drivers' as record_source

from {{ source('staging','stg_drivers') }}
where driver_id is not null