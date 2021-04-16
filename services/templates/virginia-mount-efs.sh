#!/bin/sh

apk add jq nfs-utils
apk add --update --no-cache python3 && ln -sf python3 /usr/bin/python
python3 -m ensurepip
pip3 install awscli

echo "10.10.4.8 fs-1933fc42.efs.eu-central-1.amazonaws.com" | tee -a /etc/hosts
mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport fs-1933fc42.efs.eu-central-1.amazonaws.com:/website-commons /var/www/html
mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport fs-1933fc42.efs.eu-central-1.amazonaws.com:/virginia-blog/ /var/www/blog