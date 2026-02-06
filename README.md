# Enpal dbt Assessment - Pipedrive CRM Analytics

## Project Overview

This project builds a dbt data model for Pipedrive CRM sales funnel analytics, implementing a three-layer architecture (staging → intermediate → marts) for optimal maintainability and reusability.

## Data Layers

### Sources
Defined in `models/sources.yml` - 6 Pipedrive CRM tables:
- `activity` - CRM activities (calls, meetings)
- `activity_types` - Activity type definitions
- `deal_changes` - Deal field change history
- `stages` - Pipeline stage definitions
- `users` - Sales representatives
- `fields` - Custom field definitions

### Staging Layer (`models/staging/`)
Clean and standardize source data with minimal transformations.

### Intermediate Layer (`models/intermediate/`)
Business logic transformations:
- `int_deal_stage_history` - Tracks when deals enter each pipeline stage
- `int_deal_activities` - Maps activities to funnel steps (Sales Calls)

### Mart Layer (`models/marts/`)
Business-facing models including the final report.

---

## Sales Funnel Report

**Model:** `rep_sales_funnel_monthly`

**Columns:** `month`, `kpi_name`, `funnel_step`, `deals_count`

### Funnel Steps (KPIs)

| Step | KPI Name | Data Source |
|------|----------|-------------|
| 1 | Lead Generation | Pipeline Stage |
| 2 | Qualified Lead | Pipeline Stage |
| 2.1 | Sales Call 1 | Activity (type='meeting') |
| 3 | Needs Assessment | Pipeline Stage |
| 3.1 | Sales Call 2 | Activity (type='sc_2') |
| 4 | Proposal/Quote Preparation | Pipeline Stage |
| 5 | Negotiation | Pipeline Stage |
| 6 | Closing | Pipeline Stage |
| 7 | Implementation/Onboarding | Pipeline Stage |
| 8 | Follow-up/Customer Success | Pipeline Stage |
| 9 | Renewal/Expansion | Pipeline Stage |

---

## Setup & Run

```bash
# Start database
docker compose up -d

# Load data (Windows)
docker exec enpal-db-1 psql -U admin -d postgres -c "\COPY stages FROM '/raw_data/stages.csv' DELIMITER ',' CSV HEADER;"
docker exec enpal-db-1 psql -U admin -d postgres -c "\COPY activity_types FROM '/raw_data/activity_types.csv' DELIMITER ',' CSV HEADER;"
docker exec enpal-db-1 psql -U admin -d postgres -c "\COPY users FROM '/raw_data/users.csv' DELIMITER ',' CSV HEADER;"
docker exec enpal-db-1 psql -U admin -d postgres -c "\COPY fields FROM '/raw_data/fields.csv' DELIMITER ',' CSV HEADER;"
docker exec enpal-db-1 psql -U admin -d postgres -c "\COPY activity FROM '/raw_data/activity.csv' DELIMITER ',' CSV HEADER;"
docker exec enpal-db-1 psql -U admin -d postgres -c "\COPY deal_changes FROM '/raw_data/deal_changes.csv' DELIMITER ',' CSV HEADER;"

# Run dbt
pip install dbt-postgres
dbt debug
dbt run
dbt test
```

---

## Author

**Prakriti Jain** - prakriti.ps.jain@gmail.com
