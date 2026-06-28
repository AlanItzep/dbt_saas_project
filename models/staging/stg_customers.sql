{{
  config(
    materialized='view',
    tags=['staging', 'customers']
  )
}}

-- Staging layer: Clean and standardize raw customer data
-- Removes nulls, standardizes column names, and validates data types

with raw_data as (
  select
    customer_id,
    customer_name,
    company_name,
    email,
    country,
    signup_date,
    contract_value_usd
  from {{ source('raw', 'raw_customers') }}
)

select
  customer_id,
  customer_name,
  company_name,
  email,
  country,
  signup_date::date as signup_date,
  contract_value_usd::decimal(10, 2) as contract_value_usd,
  current_date() as dbt_load_date
from raw_data
where customer_id is not null
  and email is not null
