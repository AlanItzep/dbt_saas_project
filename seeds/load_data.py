"""
Load sample SaaS data into DuckDB for DBT project.
"""

import duckdb
from pathlib import Path

project_root = Path(__file__).parent.parent
data_dir = project_root / "data"
db_path = project_root / "saas_analytics.duckdb"

print("🔧 Loading SaaS data into DuckDB...")

conn = duckdb.connect(str(db_path))

try:
    # Create raw schema
    conn.execute("CREATE SCHEMA IF NOT EXISTS raw")
    
    # Drop existing tables if they exist
    conn.execute("DROP TABLE IF EXISTS raw.raw_customers")
    conn.execute("DROP TABLE IF EXISTS raw.raw_subscriptions")
    conn.execute("DROP TABLE IF EXISTS raw.raw_events")
    
    # Load CSVs into raw schema
    print(f"📥 Loading customers...")
    conn.execute(f"CREATE TABLE raw.raw_customers AS SELECT * FROM read_csv_auto('{data_dir}/customers.csv')")
    
    print(f"📥 Loading subscriptions...")
    conn.execute(f"CREATE TABLE raw.raw_subscriptions AS SELECT * FROM read_csv_auto('{data_dir}/subscriptions.csv')")
    
    print(f"📥 Loading events...")
    conn.execute(f"CREATE TABLE raw.raw_events AS SELECT * FROM read_csv_auto('{data_dir}/events.csv')")
    
    # Verify
    print("\n📊 Data verification:")
    print(f"   Customers: {conn.execute('SELECT COUNT(*) FROM raw.raw_customers').fetchall()[0][0]} rows")
    print(f"   Subscriptions: {conn.execute('SELECT COUNT(*) FROM raw.raw_subscriptions').fetchall()[0][0]} rows")
    print(f"   Events: {conn.execute('SELECT COUNT(*) FROM raw.raw_events').fetchall()[0][0]} rows")
    
    print(f"\n✅ Data loaded successfully!")

except Exception as e:
    print(f"\n❌ Error: {e}")
    raise

finally:
    conn.close()