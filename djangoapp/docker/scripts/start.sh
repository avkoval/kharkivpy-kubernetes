#!/bin/bash

WHAT=$1
echo "Starting $WHAT"

wait_port() {
  #
  # $1 - host, $2 -port
  #
  until nc -z $1 $2
  do
    echo "Waiting for $1:$2"
    sleep 1
  done
}

wait_db() {
  #
  # $1 - host, $2 - port, $3 - db, $4 - user, $5 - pass, $6 - wait in sec (default 60)
  #
  WAIT=${6:-60}
  if wait_port $1 $2 $WAIT; then
    for i in $(seq 1 $WAIT); do
      if PGPASSWORD=$5 psql -h $1 -U $4 -d $3 -c '\l' -o /dev/null; then
        return 0
      else
        >&2 echo "Waiting for db $3 on host $1 ($i sec)"
        sleep 1
      fi
    done
  fi
  return 1
}

clean_pyc() {
  find . -name "*.pyc" -delete > /dev/null 2>&1
}

cleanup()
{
  kill -s SIGTERM $!
  exit 0
}

trap cleanup SIGINT SIGTERM

. /etc/profile
export LD_LIBRARY_PATH="/usr/lib/x86_64-linux-gnu/"

cd /worker/code
export PYTHONPATH="$PYTHONPATH:/worker/code"

if [[ ${WHAT} == "web" ]]; then
  clean_pyc
  # wait_db 'db' ${POSTGRES_PORT} ${POSTGRES_DB} ${POSTGRES_USER} ${POSTGRES_PASSWORD}
  #python /worker/code/helloworld/manage.py compilemessages
  while [ 1 ]; do
      cd /worker/code
      python /worker/code/helloworld/manage.py runserver 0.0.0.0:8000
      sleep 2
  done
fi

if [[ ${WHAT} == "run_info" ]]; then
  echo "Check your server running at:"
  echo "http://helloworld.127.0.0.1.nip.io:${HOST_WEB_PORT}/"
fi

if [[ "$DEBUG_START_SCRIPT" == "1" ]]; then
  tail -f /dev/null
fi
