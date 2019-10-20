#!/bin/bash
HC_FOLDER=`dirname $BASH_SOURCE`

. ./$HC_FOLDER/../config.ini

echo $HOST_IPS

cat /dev/zero | ssh-keygen -q -N "" 2> /dev/null

PUB_KEY=`cat ~/.ssh/id_rsa.pub`

echo " PUB key is $PUB_KEY"

echo $PUB_KEY >> ~/.ssh/authorized_keys

for HOST_IP in $HOST_IPS; do

	echo $HOST_IP 
	ssh root@$HOST_IP "  mkdir ~/.ssh 2>/dev/null"
	ssh root@$HOST_IP " echo $PUB_KEY >> ~/.ssh/authorized_keys"
done

echo "Passwd less access done - loging in one more time"
for HOST_IP in $HOST_IPS; do

	echo $HOST_IP 
	ssh root@$HOST_IP "ls"
done
