# SaaS Analytics Warehouse — DBT Portfolio Project

A production-ready **data warehouse** for a fictional SaaS company, built with **DBT Core** and **DuckDB**. This project demonstrates end-to-end data engineering skills: raw data ingestion, layered transformations, testing, and documentation.

## 📊 Project Overview

This project builds an analytics warehouse that answers key business questions:
- What is our Monthly Recurring Revenue (MRR) and Annual Recurring Revenue (ARR)?
- Which customers are churning or at risk?
- How engaged are customers with our platform?
- What revenue opportunities exist in add-on features?

## 🏗️ Architecture

```
Raw CSV Data → DuckDB → DBT Transformations → Analytics Tables
     ↓              ↓           ↓                    ↓
  customers    raw_*         stg_*          mart_revenue
  subscriptions   tables    staging         mart_engagement
  events                    models          (Business-ready)
```

**Data Flow Layers:**

1. **Raw Layer** (`raw_*` tables)
   - Loaded directly from CSV files by `seeds/load_data.py`
   - No transformation, no validation yet

2. **Staging Layer** (`stg_*` views)
   - Data cleaning: null handling, type casting
   - Column standardization and renaming
   - Basic validation (not null, unique checks)

3. **Mart Layer** (`mart_*` tables)
   - Business logic implementation
   - Joins and aggregations
   - Analytics-ready tables for BI tools

## 🚀 Quick Start

### Prerequisites
```bash
# Python 3.8+
python --version

# Install DuckDB and DBT
pip install duckdb dbt-duckdb pandas
```

### Setup (5 minutes)

1. **Clone this repo:**
```bash
git clone https://github.com/AlanItzep/dbt_fundamentals.git
cd dbt_fundamentals
```

2. **Load sample data into DuckDB:**
```bash
python seeds/load_data.py
```
Output: `saas_analytics.duckdb` (SQLite-like database)

3. **Configure DBT profiles:**
```bash
# Copy profiles to DBT config directory
mkdir -p ~/.dbt
cp profiles.yml ~/.dbt/profiles.yml

# Or set environment variable
export DBT_PROFILES_DIR=$(pwd)
```

4. **Run transformations:**
```bash
# Install DBT dependencies
dbt deps

# Run all models (staging → marts)
dbt run

# Validate data quality
dbt test
```

Expected output:
```
Running with dbt 1.5.0
Found 5 models, 8 tests
Executing... [=====] 100% Done. 5 created in 2.35s.
Executed 8 tests, all passed.
```

5. **Generate documentation:**
```bash
dbt docs generate
dbt docs serve
```
Visit `http://localhost:8000` to explore data lineage and column-level documentation.

## 📁 Project Structure

```
dbt_fundamentals/
├── data/                      # Sample CSV files
│   ├── customers.csv          # 20 fictional customers
│   ├── subscriptions.csv       # Active subscriptions
│   └── events.csv             # User activity events
│
├── models/
│   ├── staging/               # Data cleaning & standardization
│   │   ├── stg_customers.sql
│   │   ├── stg_subscriptions.sql
│   │   └── stg_events.sql
│   │
│   ├── marts/                 # Analytics-ready tables
│   │   ├── mart_revenue_metrics.sql      # MRR, ARR, customer value
│   │   └── mart_customer_engagement.sql  # Activity & feature usage
│   │
│   └── schema.yml             # Data documentation & tests
│
├── seeds/
│   └── load_data.py           # Load CSVs into DuckDB
│
├── tests/                     # Custom data quality tests (optional)
├── dbt_project.yml            # DBT configuration
├── profiles.yml               # DuckDB connection config
└── README.md                  # This file
```

## 🔍 What Gets Created

After running `dbt run`, you'll have these tables in DuckDB:

### Staging Tables (Views)
- **stg_customers** — Cleaned customer data
- **stg_subscriptions** — Cleaned subscription records
- **stg_events** — Cleaned user events

### Mart Tables (Analytics-Ready)
- **mart_revenue_metrics** — Customer revenue breakdown
  - MRR (Monthly Recurring Revenue)
  - ARR (Annual Recurring Revenue)
  - Contract value and plan tier
  
- **mart_customer_engagement** — Activity metrics
  - Login frequency
  - Feature adoption
  - Engagement level (Very Active → Inactive)
  - Add-on revenue

## 📊 Sample Query: Revenue Report

```sql
-- Top customers by ARR
select
  customer_name,
  company_name,
  plan_tier,
  monthly_recurring_revenue as mrr,
  annualized_revenue as arr
from marts.mart_revenue_metrics
where is_active = true
order by annualized_revenue desc
limit 10;
```

## ✅ Data Quality

This project includes **8 automated tests**:
- Unique & not-null constraints on primary keys
- Relationship validations (foreign keys)
- Custom business rules (optional)

Run tests:
```bash
dbt test
```

## 🎯 Key Features Demonstrated

✓ **Layered Modeling** — Raw → Staging → Marts pattern  
✓ **Data Testing** — Schema tests, uniqueness, not-null  
✓ **Documentation** — Column-level docs with dbt docs  
✓ **SQL Optimization** — Window functions, CTEs, aggregations  
✓ **Business Logic** — MRR, churn, engagement calculations  
✓ **Incremental Loads** — Ready for scalable data (optional)  
✓ **Git-Friendly** — Version control of data logic  

## 🔧 Technology Stack

| Component | Technology |
|-----------|------------|
| **Data Warehouse** | DuckDB (local, fast, SQL-based) |
| **Transformation** | DBT Core (open-source) |
| **Language** | SQL + Jinja2 templating |
| **Data Ingestion** | Python (Pandas + DuckDB) |
| **Version Control** | Git |

## 📈 Scaling This Project

This project uses DuckDB for simplicity, but the SQL is compatible with:
- ✓ Snowflake (primary use case)
- ✓ BigQuery
- ✓ Redshift
- ✓ PostgreSQL

To switch databases, update `profiles.yml` and `dbt_project.yml`.

## 🚀 Production Deployment

To deploy to production (Snowflake, BigQuery, etc.):

1. Replace DuckDB with your data warehouse in `profiles.yml`
2. Add incremental models for large datasets
3. Set up CI/CD with `dbt Cloud` or GitHub Actions
4. Add data freshness checks and SLAs

Example for Snowflake:
```yaml
saas_analytics:
  outputs:
    prod:
      type: snowflake
      account: xy12345.us-east-1
      user: dbt_user
      password: "{{ env_var('DBT_PASSWORD') }}"
      role: transformer
      database: analytics
      schema: marts
      threads: 4
```

## 📚 Learning Resources

- [DBT Docs](https://docs.getdbt.com/)
- [DBT Best Practices](https://docs.getdbt.com/guides/best-practices)
- [DuckDB SQL](https://duckdb.org/docs/sql/introduction)

## 💡 Next Steps

1. **Clone and run locally** (takes 5 mins)
2. **Modify sample data** in `data/` CSVs
3. **Add custom marts** for your use case
4. **Deploy to Snowflake/BigQuery** with your real data

## 📝 Notes

- All sample data is **completely fictional**
- Safe to share publicly on GitHub
- Database file is not version controlled (`.gitignore`)
- Models are DuckDB-compatible and database-agnostic

## 📧 Contact

Built by Alan Itzep | [LinkedIn](https://www.linkedin.com/in/alan-itzep/) | [GitHub](https://github.com/AlanItzep)

---

**Ready to use this as your portfolio project?**
1. Clone the repo
2. Run `python seeds/load_data.py`
3. Run `dbt run && dbt test`
4. Push to your GitHub and share with potential clients!