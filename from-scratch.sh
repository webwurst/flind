#!/bin/env bash

docker-compose down
# +volumes?

export ETCD_DISCOVERY=$(curl -fsS "https://discovery.etcd.io/new?size=3")

docker-compose up -d
docker-compose scale fleet=5

sleep 3
docker exec -ti flind_fleet_1 etcdctl member list

sleep 1
docker exec -ti flind_fleet_1 fleetctl list-machines

docker exec -ti flind_fleet_1 docker info
docker exec -ti flind_fleet_1 docker run alpine env
docker exec -ti flind_fleet_1 curl http://registry-proxy:5000/v2/

# docker exec -ti flind_fleet_1 bash
