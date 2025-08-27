# 🔖 Changelog

## Unreleased

## v0.2.1 (2025-08-27)

Chores:

- Update the description of the BigQuery table columns.

## v0.2.0 (2025-08-27)

Breaking changes:

- Use `JSON` and `BYTES` by default for BigQuery raw events `data` and `attributes` columns. Types can be overridden using the `bigquery_raw_events_data_type` and `bigquery_raw_events_attributes_type` variables.

## v0.1.2 (2024-08-30)

Chores:

- Upgrade compatible `google` provider versions to support `6.*.*`.

## v0.1.1 (2024-02-21)

Chores:

- Upgrade compatible `google` provider versions to support `5.*.*`.

## v0.1.0 (2023-07-28)

Features:

- Implement the first version of the module, managing Pub/Sub topics and BigQuery tables for raw events.
