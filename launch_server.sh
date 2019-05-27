#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ -e "${DIR}/PDNSENV/bin/python" ]; then
    ENV_PY="${DIR}/PDNSENV/bin/python"
else
    echo "Please make sure you ran install_server.py first."
    exit 1
fi

screen -dmS "pdns"
sleep 0.1

screen -S "pdns" -X screen -t "pdns-lookup-redis" bash -c "(/home/d4/analyzer-d4-passivedns/redis/src/redis-server /home/d4/analyzer-d4-passivedns/etc/redis.conf; read x;)"
screen -S "pdns" -X screen -t "pdns-ingester" bash -c ${ENV_PY}' ./bin/pdns-ingestion.py;'
screen -S "pdns" -X screen -t "pdns-cof" bash -c ${ENV_PY}' ./bin/pdns-cof-server.py;'

exit 0