#!/usr/bin/env bash
yum update -y
yum -y install docker ; /sbin/service docker start 
docker build --tag example/node:latest --file ${PWD}/Dockerfile ${PWD} 
