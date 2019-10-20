#!/bin/bash

### USER INPUT



#######Do not modify

LOG () {
	echo "$1"
	sleep 2
}


LOG "Deploy and setup TixChange on K8s." 
LOG " *********"
LOG "1. Make sure HOST_IP field is updated in config.ini and yes it is IP not host name"
LOG "2. Make sure ssh key is setup among all your nodes to connect from this box without passwd"
LOG "3. Make sure you have 40G available in /opt/"
LOG "4. Make sure you run this as root"
LOG "5. Script assumes the install folder is $INSTALL_FOLDER"
LOG " *********"

LOG "OK to proceed. Enter or Ctrl-C"

read input


LOG " disabling firewall, SELinux off etc"
systemctl stop firewalld
systemctl disable firewalld

setenforce 0
sed -i s/^SELINUX=.*$/SELINUX=disabled/ /etc/selinux/config

swapoff -a
systemctl daemon-reload
systemctl restart kubelet

LOG "Getting KubeSpray "

#wget https://github.com/kubernetes-sigs/kubespray/archive/master.zip
wget https://github.com/kubernetes-sigs/kubespray/archive/release-2.10.zip


rm -rf $INSTALL_FOLDER
mkdir -p $INSTALL_FOLDER
cp -rf ../ $INSTALL_FOLDER
cd $INSTALL_FOLDER

ESCAPE_INSTALL_FOLDER=$(echo "$INSTALL_FOLDER" | sed 's/\//\\\//g')
sed 's/DOCKER_STORAGE_FOLDER/'$ESCAPE_INSTALL_FOLDER\\/DockerStorage'/' all.yml

#unzip master.zip &&  mv kubespray-master kubespray && cd kubespray
unzip release-2.10.zip &&  mv kubespray-release-2.10 kubespray && cd kubespray


# needed for pip
yum --enablerepo=extras install epel-release

export LC_ALL=C

yum install -y python-pip python36 iproute wget nfs-utils

LOG "Installing the requirements for Kubespray"
sleep 1

export LC_ALL=C

which pip
pip -V

sleep 2

pip install -r requirements.txt

sleep 1
rm -fr inventory/mycluster
cp -r inventory/local/ inventory/mycluster && rm -f inventory/mycluster/hosts.ini


#declare -a IPS=(10.74.240.100 10.74.240.101 10.74.240.102)
declare -a IPS=($HOST_IPS)
CONFIG_FILE=inventory/mycluster/hosts.yml /usr/bin/python3.6m contrib/inventory_builder/inventory.py ${IPS[@]}

cp -f ../automation/*.yml inventory/mycluster/group_vars/
cp -f ../automation/ansible.cfg .

### KubeSpray install

ansible-playbook -b --become-user=root -v -i  inventory/mycluster/hosts.yml --user=root cluster.yml --flush-cache


kubectl label node node3 node-role.kubernetes.io/worker=worker

LOG "*****"
LOG "K8s install is done... see the output of kubectl get nodes - if this doesnt look right pls Ctrl-C and debug"


kubectl get nodes

read INPUT

### Helm Install


### UMA install

## TixCange Helm Install


### Jmeter Install

#wget https://www-eu.apache.org/dist//jmeter/binaries/apache-jmeter-5.1.1.tgz
#tar xvf apache-jmeter-5.1.1.tgz

export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.212.b04-0.el7_6.x86_64/jre
export JMETER_HOME=/opt/ca/jmeter/apache-jmeter-5.1.1
