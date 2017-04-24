# GitBucket-docker

## Getting started

### When using Docker Compose
```shell
export http_proxy=http://your_proxy_host:your_proxy_port/
export https_proxy=http://your_proxy_host:your_proxy_port/
export HTTP_PROXY=$http_proxy
export HTTPS_PROXY=$https_proxy
export no_proxy=`docker-machine ip default`
export NO_PROXY=$no_proxy

docker-compose up -d
```
### When not using Docker Compose(e.g. Windows 32bit)
```shell
export http_proxy=http://your_proxy_host:your_proxy_port/
export https_proxy=http://your_proxy_host:your_proxy_port/
export HTTP_PROXY=$http_proxy
export HTTPS_PROXY=$https_proxy
export no_proxy=`docker-machine ip default`
export NO_PROXY=$no_proxy

docker-machine scp run_for_32bit_os.sh default:/tmp/gitbucket_run_for_32bit_os.sh
docker-machine ssh default
sh /tmp/gitbucket_run_for_32bit_os.sh
rm -f /tmp/gitbucket_run_for_32bit_os.sh
```

# For developers

## How to build and run

### When using Docker Compose
```shell
export http_proxy=http://your_proxy_host:your_proxy_port/
export https_proxy=http://your_proxy_host:your_proxy_port/
export HTTP_PROXY=$http_proxy
export HTTPS_PROXY=$https_proxy
export no_proxy=`docker-machine ip default`
export NO_PROXY=$no_proxy

docker-compose -f docker-compose-build.yml build
docker-compose -f docker-compose-build.yml up -d
```
### When not using Docker Compose(e.g. Windows 32bit)
```shell
export http_proxy=http://your_proxy_host:your_proxy_port/
export https_proxy=http://your_proxy_host:your_proxy_port/
export HTTP_PROXY=$http_proxy
export HTTPS_PROXY=$https_proxy
export no_proxy=`docker-machine ip default`
export NO_PROXY=$no_proxy

docker image build -t gitbucketdocker_db db

docker image build -t gitbucketdocker_app \
  --build-arg http_proxy=$http_proxy \
  --build-arg https_proxy=$https_proxy \
  app

docker volume create --name gitbucketdocker_db-data
docker volume create --name gitbucketdocker_app-data

docker-machine ssh default

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
  gitbucketdocker_db

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
  gitbucketdocker_app
```
