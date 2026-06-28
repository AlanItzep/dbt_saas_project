{{
  config(
    materialized='view',
    tags=['staging', 'subscriptions']
  )
}}

-- Staging layer: Clean and standardize raw subscription data
-- Removes nulls, standardizes types, calculates derived fields

with raw_data as (
  select
    subscription_id,
    customer_id,
    subscription_plan,
    plan_tier,
    monthly_fee_usd,
    start_date,
    end_date,
    is_active,
    billing_cycle
  from {{ source('raw', 'raw_subscriptions') }}
)

select
  subscription_id,
  customer_id,
  subscription_plan,
  plan_tier,
  monthly_fee_usd::decimal(10, 2) as monthly_fee_usd,
  start_date::date as start_date,
  end_date::date as end_date,
  is_active::boolean as is_active,
  billing_cycle,
  case
    when billing_cycle = 'annual' then monthly_fee_usd * 12
    else monthly_fee_usd
  end::decimal(10, 2) as annual_value_usd,
  current_date() as dbt_load_date
from raw_data
where subscription_id is not null
  and customer_id is not null
  and start_date is not null
