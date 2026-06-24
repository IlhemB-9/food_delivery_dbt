{{ config(materialized='table', schema='data_vault') }}

select distinct
    md5(
        coalesce(trim(lower(delivery_id::text)),'') || '|' ||
        coalesce(trim(lower(driver_id::text)),'')
    ) as link_delivery_driver_hk,

    md5(trim(lower(delivery_id::text))) as delivery_hk,
    md5(trim(lower(driver_id::text))) as driver_hk,

    current_timestamp as load_date,
    'staging.stg_deliveries' as record_source

from {{ source('staging','stg_deliveries') }}
where delivery_id is not null
  and driver_id is not null