# Fleet in Docker

See [`from-scratch.sh`](https://github.com/webwurst/flind/blob/master/from-scratch.sh) how to start up.

```bash
./from-scratch.sh

docker exec flind_fleet_1 etcdctl member list

docker exec flind_fleet_1 fleetctl list-machines
docker exec flind_fleet_1 fleetctl list-units
```
