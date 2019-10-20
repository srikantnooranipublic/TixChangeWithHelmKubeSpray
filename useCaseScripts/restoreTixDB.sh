#!/bin/bash

echo "pls run mainInstaller.sh and use option \"t\""

exit


########Sorry not being used 

CURRENT_FOLDER=`dirname $BASH_SOURCE`

echo "Current Folder $CURRENT_FOLDER"

cd /opt/ca/TixChangeK8sDemo/tixChangeHelm

helm ls
helm delete tixchange --purge
sleep 5
helm delete tixchange --purge 2> /dev/null
sleep 20
kubectl delete ns tixchange-v1
kubectl delete ns tixchange-v2


#kubectl create ns tixchange-v1
#kubectl create ns tixchange-v2
sleep 25

kubectl get pods -n tixchange-v1

helm install  . --name tixchange

sleep 5

kubectl create configmap default-basnippet --namespace=tixchange-v1 --from-file=./default.basnippet
kubectl create configmap jtixchange-pbd --namespace=tixchange-v2 --from-file=./jtixchange.pbd
kubectl create configmap jtixchange-pbd --namespace=tixchange-v1 --from-file=./jtixchange.pbd

sleep 10 

TIX_IP=`kubectl get svc -n tixchange-v1|grep -v grep |grep webport|grep -v NAME|awk '{print $3}'`

sed -i "s/value: 10.*$/value: $TIX_IP/g" /opt/ca/TixChangeK8sDemo/bpa/tix_bpa_deploy_v1.yaml

kubectl create -f /opt/ca/TixChangeK8sDemo/bpa/tix_bpa_deploy_v1.yaml -n tixchange-v1

sleep 5

cd /opt/ca/TixChangeK8sDemo/em/
./setupEMSideConfigurations1.sh


