{{
  config(
    materialized='table',
    tags=['marts', 'engagement']
  )
}}

-- Engagement Mart: Customer activity and feature usage metrics
-- Tracks logins, feature adoption, and engagement patterns

with customers as (
  select * from {{ ref('stg_customers') }}
),

events as (
  select * from {{ ref('stg_events') }}
),

customer_events as (
  select
    c.customer_id,
    c.customer_name,
    c.company_name,
    e.event_type,
    e.feature_used,
    e.event_date,
    e.value_usd
  from customers c
  left join events e on c.customer_id = e.customer_id
)

select
  customer_id,
  customer_name,
  company_name,
  count(distinct case when event_type = 'login' then event_date else null end) as login_days_last_month,
  count(*) as total_events_last_month,
  count(distinct case when event_type = 'export_report' then 1 else null end) as export_report_count,
  count(distinct case when event_type = 'custom_report' then 1 else null end) as custom_report_count,
  count(distinct case when event_type = 'api_call' then 1 else null end) as api_call_count,
  count(distinct feature_used) as distinct_features_used,
  sum(value_usd) as addon_revenue_last_month,
  max(event_date) as last_activity_date,
  case
    when max(event_date) >= current_date() - 7 then 'Very Active'
    when max(event_date) >= current_date() - 30 then 'Active'
    when max(event_date) >= current_date() - 90 then 'Moderate'
    else 'Inactive'
  end as engagement_level,
  current_date() as dbt_load_date
from customer_events
group by
  customer_id,
  customer_name,
  company_name
