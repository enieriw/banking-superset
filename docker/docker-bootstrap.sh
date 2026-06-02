#!/usr/bin/env bash
set -eo pipefail

SERVICE="$1"

if [ "$SERVICE" = "app" ]; then
  echo "Starting Superset dev server"
  flask run -p 8088 --with-threads --reload --debugger --host=0.0.0.0
elif [ "$SERVICE" = "app-gunicorn" ]; then
  echo "Starting Superset gunicorn server"
  gunicorn \
    --bind "0.0.0.0:${SUPERSET_PORT:-8088}" \
    --access-logfile '-' \
    --error-logfile '-' \
    --workers 1 \
    --worker-class gthread \
    --threads 20 \
    --timeout 60 \
    --limit-request-line 0 \
    --limit-request-field_size 0 \
    "${FLASK_APP:-superset.app:create_app()}"
elif [ "$SERVICE" = "worker" ]; then
  echo "Starting Superset Celery worker"
  celery --app=superset.tasks.celery_app:app worker -O fair -c 4
elif [ "$SERVICE" = "beat" ]; then
  echo "Starting Superset Celery beat"
  celery --app=superset.tasks.celery_app:app beat --pidfile /tmp/celerybeat.pid -s /tmp/celerybeat-schedule
else
  echo "Unknown service: $SERVICE"
  exit 1
fi
