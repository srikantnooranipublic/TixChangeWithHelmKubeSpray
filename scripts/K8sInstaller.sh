#!/bin/bash
SCRIPTS_FOLDER=`dirname $BASH_SOURCE`
. $SCRIPTS_FOLDER/include.sh


wget https://github.com/kubernetes-sigs/kubespray/archive/release-2.10.zip


#ESCAPE_INSTALLATION_FOLDER=$(echo "$INSTALLATION_FOLDER" | sed 's/\//\\\//g')
#sed -i 's/DOCKER_STORAGE_FOLDER/'$ESCAPE_INSTALLATION_FOLDER\\/DockerStorage'/' all.yml

rm -rf $INSTALLATION_FOLDER/$KUBESPRAY_FOLDER

#unzip master.zip &&  mv kubespray-master kubespray && cd kubespray
unzip release-2.10.zip &&  mv kubespray-release-2.10/ $INSTALLATION_FOLDER/$KUBESPRAY_FOLDER 

rm -rf release-2.10.zip*

cd $INSTALLATION_FOLDER/$KUBESPRAY_FOLDER

export LC_ALL=C

logMsg "Installing Kubespray pre-preq "

/usr/local/bin/pip install -r requirements.txt

sleep 2
#rm -fr inventory/mycluster
#cp -fpr inventory/sample/ inventory/mycluster && rm -f inventory/mycluster/hosts.yml
cp -r inventory/local/ inventory/mycluster && rm -f inventory/mycluster/hosts.ini

export LC_ALL=C

pip -V

declare -a IPS=($HOST_IPS)
CONFIG_FILE=inventory/mycluster/hosts.yml /usr/bin/python3.6m contrib/inventory_builder/inventory.py ${IPS[@]}

cd -

cp -f $SCRIPTS_FOLDER/k8s-cluster.yml  $INSTALLATION_FOLDER/$KUBESPRAY_FOLDER/inventory/mycluster/group_vars/k8s-cluster/
cp -f $SCRIPTS_FOLDER/addons.yml  $INSTALLATION_FOLDER/$KUBESPRAY_FOLDER/inventory/mycluster/group_vars/k8s-cluster/
cp -f $SCRIPTS_FOLDER/ansible.cfg  $INSTALLATION_FOLDER/$KUBESPRAY_FOLDER 

cd -


### KubeSpray install

ansible-playbook -b --become-user=root -v -i  inventory/mycluster/hosts.yml --user=root cluster.yml --flush-cache

cd -

kubectl label node node3 node-role.kubernetes.io/worker=worker

logMsg "*****"
logMsg "K8s install is done... see the output of kubectl get nodes - if this doesnt look right pls Ctrl-C and debug"


sleep 6

kubectl get nodes
kubectl get pods -n kube-system
kubectl get pods -n ingress-nginx

sleep 10

logMsg "ensure everything looks good"
