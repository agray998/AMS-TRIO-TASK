#!/bin/bash

build() {
  cd db/
  docker build -t trio-db:v1 .
  cd ../flask-app
  docker build -t trio-app:v1 .
  cd ..
  docker network create trio
  docker run -d --network trio --name mysql --env MYSQL_ROOT_PASSWORD=${DB_PASSWORD} trio-db:v1
  docker run -d --network trio --name flask-app --env DB_PASSWORD=${DB_PASSWORD} -p 80:5000 trio-app:v1
}

test -z $DB_PASSWORD && echo "required variable 'DB_PASSWORD' is not set" || build

