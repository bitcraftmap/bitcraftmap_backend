#!/usr/bin/env bash

# stop and remove all containers
docker rm -f $(docker ps -aq)

# remove all volumes
docker volume rm -f $(docker volume ls -q)

# wipe images and networks
docker system prune -a --volumes -f