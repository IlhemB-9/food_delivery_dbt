{{ config(materialized='table', schema='data_vault') }}

select distinct
    md5(trim(lower(driver_id::text))) as driver_hk,
    driver_id,

    current_timestamp as load_date,
    'staging.stg_drivers' as record_source

from {{ source('staging','stg_drivers') }}
where driver_id is not null