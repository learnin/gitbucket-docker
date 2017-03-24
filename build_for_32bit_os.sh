#!/bin/bash

# db
cd db
docker image build -t gitbucketdocker_db .
cd ..

# app
cd app
docker image build -t gitbucketdocker_app \
  --build-arg http_proxy=$http_proxy \
  --build-arg https_proxy=$https_proxy \
  .
cd ..
