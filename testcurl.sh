#! /usr/bin/bash
set -x
curl  localhost:8083/films/1663
echo "----"
curl -X POST localhost:8083/films/    -H 'Content-Type: application/json'    -d '{"id":1663,"title":"Running on Empty1663"}'
echo "----"
curl  localhost:8083/films/1663
echo "----"
curl -X DELETE localhost:8083/films/    -H 'Content-Type: application/json'    -d '{"id": 1663 }'
echo "----"
curl  localhost:8083/films/1663
echo "----"

