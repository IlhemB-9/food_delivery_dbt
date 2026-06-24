{{ config(materialized='table', schema='data_vault') }}

select
    md5(trim(lower(customer_id::text))) as customer_hk,

    customer_name,
    email,
    phone_number,
    governorate,
    district,
    address,
    registration_date,
    customer_segment,
    is_active,

    md5(
        coalesce(customer_name,'') || '|' ||
        coalesce(email,'') || '|' ||
        coalesce(phone_number,'') || '|' ||
        coalesce(governorate,'') || '|' ||
        coalesce(district,'') || '|' ||
        coalesce(address,'') || '|' ||
        coalesce(customer_segment,'') || '|' ||
        coalesce(is_active::text,'')
    ) as hashdiff,

    current_timestamp as dv_load_date,
    'staging.stg_customers' as record_source

from {{ source('staging','stg_customers') }}