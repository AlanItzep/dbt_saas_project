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

- **Python 3.12+** (tested with Python 3.13)
- **DBT** (already installed, or install: `pip install dbt-duckdb`)
- **DuckDB** (will be installed via pip)

```bash
# Check Python version
python --version

# Install dependencies
pip install duckdb
```

### Setup (10 minutes)

1. **Clone this repo:**
```bash
git clone https://github.com/AlanItzep/dbt_saas_project.git
cd dbt_saas_project
```

2. **Install dependencies:**
```bash
pip install duckdb
```

3. **Load sample data into DuckDB:**
```bash
python seeds/load_data.py
```
Output: Creates `saas_analytics.duckdb` with raw tables

4. **Configure DBT profiles:**
```bash
# Option A: Copy profiles to DBT config directory
mkdir -p ~/.dbt
cp profiles.yml ~/.dbt/profiles.yml

# Option B: Set environment variable
export DBT_PROFILES_DIR=$(pwd)
```

5. **Run transformations:**
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
dbt-fusion 2.0.0
Processed: 5 models | 18 tests
Summary: 23 total | 23 success
```

6. **View results:**

**Option A: Query with Python**
```bash
python view_data.py
```

**Option B: Browse in DBeaver** (recommended)
- Download: https://dbeaver.io
- New Connection → DuckDB → Point to `saas_analytics.duckdb`
- Browse tables in left panel

**Option C: View catalog metadata**
```bash
python view_catalog.py
```

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

| Component | Technology | Version |
|-----------|------------|---------|
| **Data Warehouse** | DuckDB | 0.8+ |
| **Transformation** | DBT (Core or Fusion) | 1.5+ / 2.0+ |
| **Language** | SQL + Jinja2 | - |
| **Data Ingestion** | Python + DuckDB | Python 3.12+ |
| **Database Browser** | DBeaver (optional) | Latest |
| **Version Control** | Git | Latest |

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

## 🔧 Troubleshooting

**Issue: "Table does not exist"**
```bash
# Make sure you ran the seed script first
python seeds/load_data.py

# Then run DBT
dbt run
```

**Issue: "Schema raw does not exist"**
- The seed script creates the `raw` schema automatically
- If error persists, delete `saas_analytics.duckdb` and re-run `python seeds/load_data.py`

**Issue: dbt test fails**
```bash
# Check your data is loaded
dbt run --select stg_customers
dbt test
```

**Issue: Pandas installation fails (Python 3.13)**
- Use minimal requirements: `pip install duckdb` only
- Pandas is optional for this project

**Issue: DBeaver won't open**
- Run as Administrator
- Or use the Python scripts instead (`python view_data.py`)

## 📝 Notes

- All sample data is **completely fictional** — safe to share publicly
- Database file (`*.duckdb`) is git-ignored — not committed to GitHub
- Models are database-agnostic (work with Snowflake, BigQuery, PostgreSQL with minor changes)
- Catalog and manifest files (`target/`) show full data warehouse documentation

## 📚 Git Branching

This repo uses:
- **`main`** — Production-ready portfolio code
- **`develop`** — Development/experimental branch

Clone and work on `develop`, then merge to `main` when stable.

## 📧 Contact

Built by Alan Itzep | [LinkedIn](https://www.linkedin.com/in/alan-itzep/) | [GitHub](https://github.com/AlanItzep)

---

**Questions or improvements?** Feel free to open an issue or pull request!

---

**Ready to use this as your portfolio project?**
1. Clone the repo
2. Run `python seeds/load_data.py`
3. Run `dbt run && dbt test`
4. Push to your GitHub and share with potential clients!