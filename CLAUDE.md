# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is the dbt project for the **"Modern Data Modeling in Production"** webinar (March 11, 2026), presented jointly by SqlDBM and dbt. It demonstrates production-proven approaches to data modeling workflows, including SqlDBM's dbt manifest upload feature and dbt Fusion.

The project builds a dimensional data warehouse using TPC-H sample data in Snowflake, showcasing medallion architecture with staging, dimensional, fact, and reporting layers.

## Prerequisites

- dbt core, dbt Fusion, or dbt Platform
- Cloud Data Platform credentials (Snowflake, BigQuery, Databricks, Redshift, or Postgres)

## Common Commands

```bash
dbt run              # Execute all models
dbt build            # Run models + tests in dependency order
dbt test             # Run all data quality tests
dbt clean            # Remove target/ and dbt_packages/ directories
dbt deps             # Install dbt packages from packages.yml

# Run/test a single model
dbt run --select <model_name>
dbt test --select <model_name>

# Run a layer
dbt run --select staging.*
dbt run --select dims.*
dbt run --select fcts.*
dbt run --select reporting.*
```

## Architecture

### Layers (medallion pattern)

| Layer | Path | Materialization | Purpose |
|-------|------|-----------------|---------|
| Staging | `models/staging/modelco/` | Views | Raw transforms from TPC-H source |
| Dimensions | `models/dims/` | Incremental tables | Type 2 SCD (valid_from/valid_to/is_current) |
| Facts | `models/fcts/` | Tables | Type 1 SCD (overwrite on change) |
| Reporting | `models/reporting/` | Tables | Denormalized views for analytics |

### Data Source

Source data comes from Snowflake's built-in TPC-H sample dataset (`snowflake_sample_data.tpch_sf1`), defined in `models/sources.yaml`. Tables: customer, orders, nations, parts, suppliers, lineitems, partsupp.

### Key Patterns

**Type 2 SCD (Dimensions):** Dimension models use dbt incremental materialization to track history with `valid_from`, `valid_to`, and `is_current` columns. New records are inserted; changed records get a `valid_to` timestamp and a new current record is added.

**Type 1 SCD (Facts):** Fact models overwrite changed records in place — no history is tracked.

**Composite Keys:** Some models use composite primary keys (e.g., `part_id + supplier_id` for inventory, `line_number + sales_order_id` for lineitem).

### Configuration

- `dbt_project.yml` — project config, materialization defaults by layer
- `profiles.yml` — Snowflake connection (account: `zna84829`, warehouse: `TRANSFORMING`, database: `SDURRY_DEV`)
- `packages.yml` — external packages: `dbt_date` (date utilities), `dbt_expectations` (data quality tests)