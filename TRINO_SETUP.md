# Superset + Trino Integration Guide

## What was configured:

### 1. Trino Service Added
- Added Trino container to `docker-compose.yml`
- Created Trino configuration files in `docker/trino/etc/`
  - `config.properties` - Main Trino server config
  - `jvm.config` - JVM memory settings
  - `node.properties` - Node configuration
  - `catalog/memory.properties` - In-memory test data source

### 2. Superset Dependencies Updated
- Added `trino` to Superset service dependencies
- Superset will now wait for Trino to be healthy before starting

### 3. Dockerfile Already Prepared
- The Dockerfile already includes `pip install trino` package
- This enables Superset to connect to Trino

## How to Start the Stack:

1. **Rebuild and start all services:**
   ```bash
   docker compose up -d --build
   ```

2. **Wait for services to be healthy:**
   ```bash
   docker compose ps
   ```
   All services should show "healthy" or "running"

## Connect Superset to Trino:

### Option A: Via Superset UI (Recommended)

1. **Access Superset:**
   - Navigate to http://localhost:8088
   - Login with: admin / admin

2. **Add Trino Database:**
   - Go to Settings → Database Connections → "+ Database"
   - Select "Trino" from the list
   - Enter connection details:
     - **Display Name:** Trino
     - **Host:** `trino` (or `localhost` if connecting from external app)
     - **Port:** `8080`
     - **Catalog:** `memory` (or your desired catalog)
     - **Schema:** `default`
     - **Username:** (leave blank - not required for basic setup)
     - **Password:** (leave blank)
   - Click "Connect"
   - Click "Finish"

3. **Create a Dataset:**
   - Go to "+ Dataset"
   - Select Trino database
   - Select catalog and schema
   - Choose a table

### Option B: Via Python Configuration

Add to `docker/pythonpath_dev/superset_config.py`:

```python
SQLALCHEMY_DATABASE_URI_LIST = {
    "trino": "trino://memory@trino:8080/memory"
}
```

## Accessing Services:

- **Superset:** http://localhost:8088
- **Trino UI:** http://localhost:8080
- **Trino Query Interface:** http://localhost:8080/ui/

## Troubleshooting:

1. **Check Trino is running:**
   ```bash
   curl http://localhost:8080/v1/info
   ```

2. **View Trino logs:**
   ```bash
   docker compose logs trino
   ```

3. **View Superset logs:**
   ```bash
   docker compose logs superset
   ```

4. **Test connection from Superset container:**
   ```bash
   docker compose exec superset python -c "from trino.dbapi import connect; print(connect(host='trino', port=8080, catalog='memory'))"
   ```

## Next Steps:

1. Add actual data sources to Trino (PostgreSQL, MySQL, etc.) by creating catalog files
2. Create dashboards in Superset using Trino as data source
3. Configure additional Trino catalogs as needed

For more info on Trino catalogs, see: https://trino.io/docs/current/connector.html
