#executes shell command on multiple nodes
#assumes config.ini file with HOST_IPS variable set with IP for nodes in your cluster like below
# HOST_IPS="10.12.1.1 12.54.12.12 13.56.43.45"
#
# Author srikant.noorani@broadcom.com

#!/bin/bash

HOST_IPS="10.12.1.1 12.54.12.12 13.56.43.45"
HOST_IPS="10.74.57.152 10.74.57.153 10.74.57.154"


for host in $HOST_IPS; do echo $host; ssh root@$host " $*"; done
