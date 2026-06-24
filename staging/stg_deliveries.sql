{{ config(materialized='view', schema='staging') }}

select *
from {{ source('staging', 'stg_deliveries') }}

