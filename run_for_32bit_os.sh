#!/bin/bash

# db-data volume
docker volume create --name gitbucketdocker_db-data

# db
docker container run \
  -d \
  -e 'DATADIR=/var/lib/mysql' \
  -e 'MYSQL_ROOT_PASSWORD=gitbucket' \
  -e 'MYSQL_DATABASE=gitbucket' \
  -e 'MYSQL_USER=gitbucket' \
  -e 'MYSQL_PASSWORD=gitbucket' \
  -e 'TZ=Asia/Tokyo' \
  --name gitbucketdocker_db_1 \
  -p 50103:3306 \
  --restart unless-stopped \
  -v /etc/localtime:/etc/localtime:ro \
  -v gitbucketdocker_db-data:/var/lib/mysql \
  learnin/gitbucket-db

# app-data volume
docker volume create --name gitbucketdocker_app-data

# app
docker container run \
  -d \
  -e 'GITBUCKET_DB_HOST=db' \
  -e 'GITBUCKET_DB_NAME=gitbucket' \
  -e 'GITBUCKET_DB_USER=gitbucket' \
  -e 'GITBUCKET_DB_PASSWORD=gitbucket' \
  -e 'JAVA_OPTS=-server' \
  -e 'GITBUCKET_OPTS=--port=80' \
  -e 'TZ=Asia/Tokyo' \
  --link gitbucketdocker_db_1:db \
  --name gitbucketdocker_app_1 \
  -p 50003:80 \
  -p 29418:29418 \
  --restart unless-stopped \
  -v /etc/localtime:/etc/localtime:ro \
  -v gitbucketdocker_app-data:/gitbucket \
  learnin/gitbucket-app
