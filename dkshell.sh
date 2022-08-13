#!/bin/sh
cid=`docker ps --filter "ancestor=sdce_labs" -q`
docker exec -it $cid /bin/bash
