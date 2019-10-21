SELENIUM_PODS=`kubectl get pods -n selenium |grep -v grep|grep -v NAME|awk '{print $1}'`


while true ;
do
	for SELENIUM_POD in $SELENIUM_PODS;
	do
		echo ""
        	echo "Looping through Selenium Pods(if multiple pods are running) - showing logs for Pod $SELENIUM_POD"
        	sleep 5
		kubectl logs  --tail=50  $SELENIUM_POD -n selenium 
		#>> /opt/ca/TixChangeK8sDemo/logs/$SELENIUM_POD.Selenium.logs
		echo ""
        	echo "##### Done logs for Pod - $SELENIUM_POD - moving to next POD (if present) in 10 sec"
		sleep 10
	done

done

