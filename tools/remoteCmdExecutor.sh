#executes shell command on multiple nodes
#assumes config.ini file with HOST_IPS variable set with IP for nodes in your cluster like below
# HOST_IPS="10.12.1.1 12.54.12.12 13.56.43.45"
#
# Author srikant.noorani@broadcom.com

#!/bin/bash

HC_FOLDER=`dirname $BASH_SOURCE`

. ./$HC_FOLDER/../config.ini

for host in $HOST_IPS; do echo $host; ssh root@$host " $*"; done
