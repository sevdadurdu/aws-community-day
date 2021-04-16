#!/bin/bash
sudo yum install ec2-instance-connect -y

echo ECS_CLUSTER=community-day-cluster >> /etc/ecs/ecs.config