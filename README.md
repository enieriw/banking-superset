# Banking Superset

Banking BI stack: Apache Superset + Trino, querying the Xóm Data banking dataset (SQL Server).

## Stack
- Apache Superset (dashboards)
- Trino (query engine, SQL Server connector)
- Docker Compose

## Setup

1. Copy the catalog template and fill in your credentials:
```bash
   cp docker/trino/etc/catalog/xombank.properties.example docker/trino/etc/catalog/xombank.properties
```
2. Start the services:
```bash
   docker compose up -d
```
3. Open Superset at http://localhost:8088 and Trino at http://localhost:8081.

See [TRINO_SETUP.md](TRINO_SETUP.md) for the Trino connection details.

## Notes
- `xombank.properties` holds real credentials and is git-ignored. Never commit it.
