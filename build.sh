#!/bin/bash

build() {
  cd db/
  docker build -t trio-db:v1 .
  cd ..
  docker network create trio
  docker volume create trio
  docker run -d --network trio --name mysql --env MYSQL_ROOT_PASSWORD=${DB_PASSWORD} -v trio:/var/lib/mysql trio-db:v1
  docker run -d --network trio --name flask-app --env MYSQL_ROOT_PASSWORD=${DB_PASSWORD} agray998/trio-app:latest
  docker run -d --network trio --name nginx --mount type=bind,source=$(pwd)/nginx/nginx.conf -p 80:80 nginx:alpine
}

test -z $DB_PASSWORD && echo "required variable 'DB_PASSWORD' is not set" || build

