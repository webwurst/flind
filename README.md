# Fleet in Docker

```bash
docker-compose build

ETCD_DISCOVERY=$(curl -fsS "https://discovery.etcd.io/new?size=3")
echo "$ETCD_DISCOVERY"

docker-compose up -d
docker-compose scale fleet=5

docker exec flind_fleet_1 etcdctl member list
docker exec flind_fleet_1 fleetctl list-machines

docker exec flind_fleet_1 fleetctl list-units
```
