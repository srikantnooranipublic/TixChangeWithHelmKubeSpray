##
# TixChange Health Check - Decision Tree
##

INSTALL_SCRIPT_FOLDER=../

# Selenium OK ?
  PID=`ps -ef |grep -i sele|grep -v grep|awk '{ print $2}'`
  if [ X"$PID" == "X" ]; then
	
	IS_TEST_PASS=`grep failed $INSTALLATION_FOLDER/$SELENIUM_FOLDER/ucNohup.out`

	if [ X"$IS_TEST_PASS" != "X" ]; then
		
	echo  "*** looks like Tixchange issue - restarting - Pls have patience**"
        #$INSTALL_SCRIPT_FOLDER/healthCheck/restartTixChange.sh tixchange-v1
        #$INSTALL_SCRIPT_FOLDER/healthCheck/restartTixChange.sh tixchange-v2

	elif [ Run a curl command on the service ]

		echo "looks like  tixchange service is down"
        fi
  fi

# get UMA Status

getApmiaDaemonSetLogs.sh

# get Namespace, to node to pod to container to java process to auto attach map

getJavaAutoAttachMapping.sh
