#collect APMIA Daemonset logs from all the pods
# bundles it as APM.log.tar
# @author - srikant.noorani@broadcom.com

mkdir logs 2> /dev/null

CAAPM_PODS=`kubectl get pods -n caaiops | grep -v NAME| awk '{print $1}'`; for POD in $CAAPM_PODS; do kubectl logs $POD -n caaiops > logs/$POD.logs; done; tar cvf ApmiaDaemonSet.log.tar logs/*.logs

echo "mail ApmiaDaemonSet.log.tar to CA/BC"
