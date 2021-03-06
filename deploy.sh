#! /bin/bash

function docker-compose (){
docker run --rm \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v "$PWD:$PWD" \
    -w="$PWD" \
    docker/compose:1.24.0 $1 $2 $3 $4
}

services=("zookeeper" "kafka" "identity" "vehicle" "trip" "payment" "messaging" "simulation")

for container in ${services[*]}
do 
if ls -Art | tail -n 1 | grep $container &>/dev/null; then
echo "Updating app"
docker-compose up --no-deps -d $container &>/dev/null &
elif docker ps | grep -q $container; then
echo "Running $container";
else
echo "Starting $container"
docker-compose up --no-deps -d $container &>/dev/null &
fi
done

sleep 4
docker-compose ps
