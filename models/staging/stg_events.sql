{{
  config(
    materialized='view',
    tags=['staging', 'events']
  )
}}

-- Staging layer: Clean and standardize raw event data
-- Standardizes column names, validates data quality

with raw_data as (
  select
    event_id,
    customer_id,
    event_type,
    event_date,
    feature_used,
    value_usd
  from {{ source('raw', 'raw_events') }}
)

select
  event_id,
  customer_id,
  event_type,
  event_date::date as event_date,
  feature_used,
  value_usd::decimal(10, 2) as value_usd,
  current_date() as dbt_load_date
from raw_data
where event_id is not null
  and customer_id is not null
  and event_date is not null
