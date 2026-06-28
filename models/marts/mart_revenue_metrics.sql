{{
  config(
    materialized='table',
    tags=['marts', 'revenue'],
    pre_hook="CREATE SCHEMA IF NOT EXISTS marts"
  )
}}

-- Revenue Mart: Key financial metrics for business intelligence
-- Calculates MRR (Monthly Recurring Revenue), ARR, and customer metrics

with customers as (
  select * from {{ ref('stg_customers') }}
),

subscriptions as (
  select * from {{ ref('stg_subscriptions') }}
),

customer_subscriptions as (
  select
    c.customer_id,
    c.customer_name,
    c.company_name,
    c.country,
    c.contract_value_usd,
    s.subscription_id,
    s.subscription_plan,
    s.plan_tier,
    s.monthly_fee_usd,
    s.annual_value_usd,
    s.start_date,
    s.end_date,
    s.is_active,
    s.billing_cycle,
    row_number() over (partition by c.customer_id order by s.start_date desc) as subscription_recency_rank
  from customers c
  left join subscriptions s on c.customer_id = s.customer_id
)

select
  customer_id,
  customer_name,
  company_name,
  country,
  subscription_plan,
  plan_tier,
  is_active,
  count(distinct subscription_id) as total_subscriptions,
  sum(monthly_fee_usd) as monthly_recurring_revenue,
  sum(annual_value_usd) as annualized_revenue,
  contract_value_usd,
  start_date as earliest_subscription_date,
  current_date() as dbt_load_date
from customer_subscriptions
where subscription_recency_rank = 1
group by
  customer_id,
  customer_name,
  company_name,
  country,
  subscription_plan,
  plan_tier,
  is_active,
  contract_value_usd,
  start_date
