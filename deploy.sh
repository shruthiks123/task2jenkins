#!/usr/bin/env bash

export new_image=one2onetool
export aws_access_key=<accesskey>
export aws-secret-key=<secretkey>
export new-prod-testing="update" 

export DOCKER_ID_USER="<dockeruserid>" 
export DOCKER_PASSWORD="dockerpassword"
docker login -u="$DOCKER_USERNAME" -p="$DOCKER_PASSWORD"

docker images
docker build -t $new-image ${PWD}/Dockerfile
docker run -d -p 8089:3000 -t $new-image
docker push $DOCKER_ID_USER/$new-image

##Deploying to AWS Instance 

aws ec2 describe-instances --aws-access-key  $aws_access_key --aws-secret-key $aws_secret_key
aws ec2 authorize-security-group-ingress --group-name devops-sg --protocol tcp --port 22 --cidr 0.0.0.0/0
aws ec2 create-key-pair --key-name devops-key --query '<keypath>' --output text > mykeypair.pem
chmod 400 mykeypair.pem

Instance_ID=`aws ec2 run-instances --image-id ami-xxxxxxxx --subnet-id subnet-xxxxxxxx --security-group-ids g-xxxxxxxx --count 1 --instance-type t2.micro --key-name mykeypair --query 'Instances[0].InstanceId'`           
wait 60
Public_IpAddress=`aws ec2 describe-instances --instance-ids $Instance_ID --query 'Reservations[0].Instances[0].PublicIpAddress'`

ssh -i mykeypair.pem user@$Public_IpAddress 'docker pull $DOCKER_ID_USER/$new-image;docker build -t $new-prod-testing ${PWD}/Dockerfile;docker run -d -p 8089:3000 -t $new-prod-testing'


