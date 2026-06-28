import duckdb

conn = duckdb.connect("saas_analytics.duckdb")

print("\n" + "="*80)
print("REVENUE METRICS (raw_marts.mart_revenue_metrics)")
print("="*80 + "\n")

revenue = conn.execute("""
    SELECT 
        customer_name,
        company_name,
        plan_tier,
        monthly_recurring_revenue as mrr,
        annualized_revenue as arr
    FROM raw_marts.mart_revenue_metrics
    WHERE is_active = true
    ORDER BY annualized_revenue DESC
""").fetchall()

for row in revenue:
    print(f"  {row[0]:<20} | {row[1]:<25} | {row[2]:<12} | MRR: ${row[3]:>7.2f} | ARR: ${row[4]:>9.2f}")

print("\n" + "="*80)
print("CUSTOMER ENGAGEMENT (raw_marts.mart_customer_engagement)")
print("="*80 + "\n")

engagement = conn.execute("""
    SELECT 
        customer_name,
        login_days_last_month,
        distinct_features_used,
        engagement_level
    FROM raw_marts.mart_customer_engagement
    ORDER BY login_days_last_month DESC
""").fetchall()

for row in engagement:
    print(f"  {row[0]:<20} | Logins: {row[1]:<2} | Features: {row[2]:<2} | Level: {row[3]}")

print("\n")
conn.close()