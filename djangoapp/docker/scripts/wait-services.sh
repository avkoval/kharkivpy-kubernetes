#!/usr/bin/env bash

# PostgreSQL
if [[ -n "${POSTGRES_HOST}" && -n "${POSTGRES_PORT}" ]]; then
  echo "We need to wait for PostgreSQL at $POSTGRES_HOST:$POSTGRES_PORT"
  # waiting for postgresql
  ./docker/scripts/wait.sh ${POSTGRES_HOST} ${POSTGRES_PORT}
fi

# Redis
if [[ -n "${REDIS_HOST}" && -n "${REDIS_PORT}" ]]; then
  echo "We need to wait for Redis at $REDIS_HOST:$REDIS_PORT"
  # waiting for redis
  ./docker/scripts/wait.sh ${REDIS_HOST} ${REDIS_PORT}
fi
